class Customer::WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    event = construct_event_from_stripe
    return if event.nil?

    case event.type
    when 'checkout.session.completed'
      process_checkout_session_completed(event.data.object)
    else
      head :bad_request
    end
  end

  private

  def construct_event_from_stripe
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = Rails.application.credentials.dig(:stripe, :endpoint_secret)

    begin
      Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError => e
      Rails.logger.error "JSON::ParserError: #{e.message}"
      head :bad_request
      nil
    rescue Stripe::SignatureVerificationError => e
      Rails.logger.error "Stripe::SignatureVerificationError: #{e.message}"
      head :bad_request
      nil
    end
  end

  def process_checkout_session_completed(session)
    Rails.logger.info "Session data: #{session.inspect}"

    customer = find_customer_by_session(session)
    return if customer.nil?

    create_order_and_order_details(session, customer)

    # カート内商品を全て削除
    customer.cart_items.destroy_all
  end

  def find_customer_by_session(session)
    customer = Customer.find_by(id: session.client_reference_id)
    if customer.nil?
      Rails.logger.error "Customer not found with ID: #{session.client_reference_id}"
      head :not_found
    end
    customer
  end

  def create_order_and_order_details(session, _customer)
    ApplicationRecord.transaction do
      order = create_order(session) # sessionを元にordersテーブルにデータを挿入
      session_with_expand = Stripe::Checkout::Session.retrieve({ id: session.id, expand: ['line_items'] })
      session_with_expand.line_items.data.each do |line_item|
        create_order_details(order, line_item) # 取り出したline_itemをorder_detailsテーブルに登録
      end
    end
  end

  def create_order(session)
    Order.create!({
                    customer_id: session.client_reference_id,
                    name: session.shipping_details.name,
                    postal_code: session.shipping_details.address.postal_code,
                    prefecture: session.shipping_details.address.state,
                    address1: session.shipping_details.address.line1,
                    address2: session.shipping_details.address.line2,
                    postage: session.shipping_options[0].shipping_amount,
                    billing_amount: session.amount_total,
                    status: 'confirm_payment'
                  })
  end

  def create_order_details(order, line_item)
    product = Stripe::Product.retrieve(line_item.price.product)
    purchased_product = Product.find(product.metadata.product_id)
    raise ActiveRecord::RecordNotFound if purchased_product.nil?

    order_detail = order.order_details.create!({
                                                 product_id: purchased_product.id,
                                                 price: line_item.price.unit_amount,
                                                 quantity: line_item.quantity
                                               })
    purchased_product.update!(stock: (purchased_product.stock - order_detail.quantity)) # 購入された商品の在庫数の更新
  end
end
