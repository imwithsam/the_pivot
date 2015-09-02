class ChargesController < ApplicationController
  def create
    # Amount in cents
    @amount = calculate_amount

    create_order_for_vendors

    empty_cart

    payment_processor = PaymentProcessor.new(
      current_user.email,
      params[:stripeToken],
      @amount
    )

    if payment_processor.make_payment
      NotificationsMailer.customer_order(current_user.email,
                                         current_user.full_name,
                                         @order_ids).deliver_later
      notify_boss
      flash[:success] = "Your payment was successful and your order is placed."
      redirect_to dashboard_path
    else
      flash[:error] = "There was a problem processing your payment."
      redirect_to cart_path
    end
  end

  private

  def create_order_for_vendors
    unique_vendor_ids = {}
    @order_ids = []

    cart.cart_items.each do |cart_item|
      unique_vendor_ids[cart_item.user.id] = 0
    end

    unique_vendor_ids.each_key do |vendor_id|
      order = Order.create(
        user_id: vendor_id,
        status:  "ordered",
        customer_id: current_user.id
      )

      vendors_cart = []

      cart.cart_items.each do |item|
        if item.user_id.eql?(vendor_id)
          vendors_cart << item
        end
      end

      vendors_cart.each do |vendor_event|
        EventOrder.create(
          order_id:   order.id,
          event_id:   vendor_event.id,
          quantity:   vendor_event.quantity,
          unit_price: vendor_event.price
        )
      end

      send_vendor_email(User.find(vendor_id), order.id)
      @order_ids << order.id
    end
  end

  def calculate_amount
    total = cart.total_price * 100
    total.to_i
  end

  def add_events_to_order(id, cart)
    cart.cart_items.each do |cart_item|
      EventOrder.create(
        order_id:   id,
        event_id:   cart_item.id,
        quantity:   cart_item.quantity,
        unit_price: cart_item.price
      )
    end
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

  def send_vendor_email(vendor, order_id)
    NotificationsMailer.contact(
      vendor.email,
      "A new order has been placed through Ocho Tickets",
      "#{vendor.full_name}, " \
      "\n" \
      "A new order has been placed through Ocho Tickets by" \
      " #{current_user.full_name}." \
      "\n" \
      " For reference, your order number is: #{order_id}." \
      " Thank you for using Ocho Tickets!"
    ).deliver_later
  end
end
