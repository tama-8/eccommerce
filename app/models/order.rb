class Order < ApplicationRecord
  belongs_to :customer

  enum status: {
    # 入金待ち
    waiting_payment: 0,
    # 入金確認
    confirm_payment: 1,
    # 出荷済み
    shipped: 2,
    # 配送中
    out_of_delivery: 3,
    # 配達済み
    delivered: 4
  }

  has_many :order_details, dependent: :destroy

  # scope :waiting_payment, -> { where(status: '支払い待ち') }
  # scope :confirm_payment, -> { where(status: '支払い確認') }
  # scope :shipped, -> { where(status: '発送済み') }
  # scope :out_of_delivery, -> { where(status: '配送中') }
  # scope :delivered, -> { where(status: '配達済み') }

  def self.statuses_with_translation
    statuses.keys.map do |key|
      [I18n.t("order.statuses.#{key}"), key]
    end.to_h
  end

  scope :created_today, -> { where('orders.created_at >= ?', Time.zone.now.beginning_of_day) }
end
