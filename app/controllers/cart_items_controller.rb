class CartItemsController < ApplicationController
  before_action :set_event, only: [:create, :update, :destroy]

  def index
    @cart_items = cart.cart_items
  end

  def create
    flash[:success] = "#{@event.name} added to cart"
    cart.add_item(@event)
    session[:cart] = cart.data
    redirect_to vendor_event_path(vendor: @event.user.url, id: @event.id)
  end

  def update
    if cart.update_item_quantity(@event, params[:event][:quantity].to_i)
      session[:cart] = cart.data
    else
      flash[:warning] = "That's a bold move Cotton! But you can't set quantity below one!"
    end
    redirect_to cart_path
  end

  def destroy
    flash[:success] = "Successfully removed " \
                      "<a href=\"#{vendor_event_path(vendor: @event.user.url, id: @event.id)}\">" \
                      "#{@event.name}</a> from your cart."
    cart.delete_item(@event)
    session[:cart] = cart.data
    redirect_to cart_path
  end

  private

  def set_event
    @event = Event.find(params[:id] || params[:event_id])
  end
end
