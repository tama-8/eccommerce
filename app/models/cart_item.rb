class CartItem < ApplicationRecord
  belongs_to :customer
  belongs_to :product
  # カート内商品の合計金額は、商品の価格 × 個数
  def line_total
    product.price * quantity
  end
end
