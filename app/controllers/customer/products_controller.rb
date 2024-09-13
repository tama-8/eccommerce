class Customer::ProductsController < ApplicationController
  def index
    @products, @sort = get_products(params)
  end

  def show
    @product = Product.find(params[:id])
    @cart_item = CartItem.new
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
end
