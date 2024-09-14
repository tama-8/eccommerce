class Customer::CheckoutsController < ApplicationController
  before_action :authenticate_customer!

  def create
    line_items = current_customer.line_items_checkout
    session = create_session(line_items)
    # Allow redirection to the host that is different to the current host
    redirect_to session.url, allow_other_host: true
  end

  private

  def create_session(line_items)
    # StripeのAPIを呼び出し
    Stripe::Checkout::Session.create(
      client_reference_id: current_customer.id,
      customer_email: current_customer.email,
      # 'payment' モードは、単純な支払いを行うためのモードです
      mode: 'payment',
      payment_method_types: ['card'],
      line_items:,
      # 、日本（JP）の住所のみを許可
      shipping_address_collection: {
        allowed_countries: ['JP']
      },
      # 配送オプションを設定
      shipping_options: [
        {
          shipping_rate_data: {
            type: 'fixed_amount',
            fixed_amount: {
              amount: 500,
              currency: 'jpy'
            },
            display_name: '全国一律'
          }
        }
      ],
      success_url: "#{root_url}orders/success",
      cancel_url: "#{root_url}cart_items"
    )
  end
end
