class Customer::CartItemsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_cart_item, only: %i[increase decrease destroy]

  def index
    @cart_items = current_customer.cart_items
    # カート内商品の合計値
    @total = @cart_items.inject(0) { |sum, cart_item| sum + cart_item.line_total }
  end

  def create
    increase_or_create(params[:product_id])
    redirect_to cart_items_path, notice: '商品がカートに追加されました'
  end

  def increase
    @cart_item.increment!(:quantity, 1)
    redirect_to request.referer, notice: 'カートが更新されました'
  end

  def decrease
    decrease_or_destroy(@cart_item)
    redirect_to request.referer, notice: 'カートが更新されました'
  end

  def destroy
    @cart_item.destroy
    redirect_to request.referer, notice: 'カート内のアイテムが1つ削除されました'
  end

  private

  def set_cart_item
    @cart_item = current_customer.cart_items.find(params[:id])
  end

  def increase_or_create(product_id)
    # 商品がカートに存在すれば cart_item にそのオブジェクトを代入し、存在しない場合は nil が返す
    cart_item = current_customer.cart_items.find_by(product_id:)
    if cart_item
      # 既にカートに存在する場合、 商品の数量を1増やします。
      cart_item.increment!(:quantity, 1)
    else
      # 商品がカートに存在しない場合、新しいカートアイテムを作成し保存
      current_customer.cart_items.build(product_id:).save
    end
  end

  def decrease_or_destroy(cart_item)
    if cart_item.quantity > 1
      # quantity カラムの値を1減らし、その変更をデータベースに保存
      cart_item.decrement!(:quantity, 1)
    else
      # カートアイテムをデータベースから削除
      cart_item.destroy
    end
  end
end
