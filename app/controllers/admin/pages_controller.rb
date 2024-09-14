class Admin::PagesController < ApplicationController
  before_action :authenticate_admin!

  def home
    @orders, @selected = get_orders(params)
    today_orders = Order.created_today
    @today_total_orders = total_orders(today_orders)
    @today_total_sales = total_sales(today_orders)
  end

  private

  # eager_load メソッドを使って 1+N 問題を解消
  def get_orders(params)
    if !params[:status].present? || !Order.statuses.keys.to_a.include?(params[:status])
      return [Order.eager_load(:customer).latest,
              'all']
    end

    get_by_enum_value(params[:status])
  end

  # eager_load メソッドを使って 1+N 問題を解消
  def get_by_enum_value(status)
    case status
    when 'waiting_payment'
      [Order.latest.waiting_payment.eager_load(:customer).latest, '支払い待ち']
    when 'confirm_payment'
      [Order.latest.confirm_payment.eager_load(:customer).latest, '支払い確認']
    when 'shipped'
      [Order.latest.shipped.eager_load(:customer).latest, '発送済み']
    when 'out_of_delivery'
      [Order.latest.out_of_delivery.eager_load(:customer).latest, '配送中']
    when 'delivered'
      [Order.latest.delivered.eager_load(:customer).latest, '配達済み']
    end
  end

  def total_orders(orders)
    orders.count
  end

  def total_sales(orders)
    orders.sum(:billing_amount)
  end
end
