class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_customer, only: %i[show update]

  def index
    # preload メソッドを使って 1+N 問題を解消します。
    @customers = Customer.preload(:orders).latest
  end

  def show; end

  def update
    @customer.update(customer_params)
    redirect_to request.referer, notice: '顧客のステータスが正常に更新されました'
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:status)
  end
end
