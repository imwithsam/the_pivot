class ChargesController < ApplicationController
  def create
    create_order_for_vendors

    payment_processor = PaymentProcessor.new(
      current_user.email,
      params[:stripeToken],
      calculate_amount
    )

    empty_cart

    if payment_processor.make_payment
      send_notifications
      flash[:success] = "Your payment was successful and your order is placed."
      redirect_to dashboard_path
    else
      flash[:error] = "There was a problem processing your payment."
      redirect_to cart_path
    end
  end

  private

  def send_notifications
    notify_boss
    email_customer
  end

  def email_customer
    NotificationsMailer.customer_order(current_user, @order_ids).deliver_later
  end

  def send_vendor_order_email(order, vendor)
    NotificationsMailer.vendor_order(User.find(vendor.id),
                                     current_user,
                                     order.id).deliver_later
  end

  def create_order_for_vendors
    cart.cart_items.group_by(&:user).each do |vendor, vendors_cart|
      order = create_order(vendor)
      @order_ids = []
      @order_ids << order.id

      vendors_cart.each do |vendor_event|
        add_events_to_order(order, vendor_event)
      end

      send_vendor_order_email(order, vendor)
    end
  end

  def add_events_to_order(order, event)
    order.event_orders.create(
      event_id:   event.id,
      quantity:   event.quantity,
      unit_price: event.price
    )
  end

  def create_order(vendor)
    vendor.orders.create(
      status:      "ordered",
      customer_id: current_user.id
    )
  end

  def calculate_amount
    total = cart.total_price * 100
    total.to_i
  end

  def notify_boss
    client = Twilio::REST::Client.new(ENV["twilio_account_sid"],
                                      ENV["twilio_auth_token"])
    client.messages.create(from: "5005550006",
                           to:   "3039002304",
                           body: "You've received an order!")
  end

  def empty_cart
    session[:cart] = {}
    cart.clear
  end
end
