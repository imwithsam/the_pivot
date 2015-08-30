class Users::EventOrdersController < ApplicationController
  def destroy
    event_order = EventOrder.find(params[:id])
    event_order.destroy
    flash[:success] = "Successfully removed #{event_order.event.name}"
    redirect_to dashboard_path
  end
end
