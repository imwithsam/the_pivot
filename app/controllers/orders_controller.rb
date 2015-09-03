class OrdersController < ApplicationController
  def index
  end

  def show
    @order = Order.find(params[:id])
    customer = User.find(Order.find(params[:id]).customer_id)
    @addresses = customer.addresses
  end

  def update
    order = Order.find(params[:id])
    order.status = params[:status]
    order.save
    redirect_to dashboard_path
  end
end
