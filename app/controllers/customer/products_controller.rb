class Customer::ProductsController < ApplicationController
  before_action :authenticate_customer!, only: [:create]
  skip_before_action :verify_authenticity_token
  def index
    @products, @sort = get_products(params)

     # キーワード検索
     if params[:search].present?
      @products = @products.where('name LIKE ?', "%#{params[:search]}%")
    end

    # タグ検索
    if params[:tag].present?
      @products = @products.tagged_with(params[:tag])
    end

    # ソート条件
    if @sort == 'latest'
      @products = @products.order(created_at: :desc)
    elsif @sort == 'price_high_to_low'
      @products = @products.order(price: :desc)
    elsif @sort == 'price_low_to_high'
      @products = @products.order(price: :asc)
    end

  
  end
  

  def show
    @product = Product.find(params[:id])
    @cart_item = CartItem.new
  end

  def create
    if current_customer.nil?
      Rails.logger.error 'Current customer is nil. Unable to set client_reference_id.'
    else
      Rails.logger.info "Current customer ID: #{current_customer.id}"
    end
    # Stripe::Checkout::Sessionを作成する
    session = Stripe::Checkout::Session.create({
                                                 payment_method_types: ['card'],
                                                 line_items: [{
                                                   price_data: {
                                                     currency: 'usd',
                                                     product_data: {
                                                       name: 'Sample Product'
                                                     },
                                                     unit_amount: 1000
                                                   },
                                                   quantity: 1
                                                 }],
                                                 mode: 'payment',
                                                 success_url:,
                                                 cancel_url:,
                                                 client_reference_id: current_customer.id # 顧客IDを設定
                                               })
    Rails.logger.info "Created session ID: #{session.id}"
    Rails.logger.info "Session data: #{session.inspect}"

    # セッションのIDをビューに渡す
    render json: { id: session.id }
  end


  private

  def get_products(params)
    # 条件: `params` の中に `latest`, `price_high_to_low`, `price_low_to_high` のいずれも存在しない場合
    # 特にソート条件が指定されていない場合に、全商品を取得し、ソートは「デフォルト」という扱いに
    return Product.all, 'default' unless params[:latest] || params[:price_high_to_low] || params[:price_low_to_high]

    # 条件: `params[:latest]` が存在する場合,最新の商品を返す（Product.latest）
    # 'latest'（最新）
    return Product.latest, 'latest' if params[:latest]

    # 条件: `params[:price_high_to_low]` が存在する場合,価格が高い順にソートされた商品リストを返します。
    #  'price_high_to_low'（価格が高い順）
    return Product.price_high_to_low, 'price_high_to_low' if params[:price_high_to_low]

    # 条件: `params[:price_low_to_high]` が存在する場合,、価格が低い順にソートされた商品リストを返します。
    #  'price_low_to_high'（価格が低い順）
    [Product.price_low_to_high, 'price_low_to_high'] if params[:price_low_to_high]
  end

  def product_params
    params.require(:product).permit(:name, :price, :description, :tag_list)
  end
end