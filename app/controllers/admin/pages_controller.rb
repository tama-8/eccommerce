class Admin::PagesController < ApplicationController
  before_action :authenticate_admin!

  def home
    @orders, @selected = get_orders(params)
    today_orders = Order.created_today
    @today_total_orders = total_orders(today_orders)
    @today_total_sales = total_sales(today_orders)
  end

  private

  def get_orders(params)
    if !params[:status].present? || !Order.statuses.keys.to_a.include?(params[:status])
      return [Order.latest,
              'all']
    end

    get_by_enum_value(params[:status])
  end

  def get_by_enum_value(status)
    case status
    when 'waiting_payment'
      [Order.latest.waiting_payment, '支払い待ち']
    when 'confirm_payment'
      [Order.latest.confirm_payment, '支払い確認']
    when 'shipped'
      [Order.latest.shipped, '発送済み']
    when 'out_of_delivery'
      [Order.latest.out_of_delivery, '配送中']
    when 'delivered'
      [Order.latest.delivered, '配達済み']
    end
  end

  def total_orders(orders)
    orders.count
  end

  def total_sales(orders)
    orders.sum(:billing_amount)
  end
end
