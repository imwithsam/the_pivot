class ChargesController < ApplicationController
  def create
    # Amount in cents
    @amount        = calculate_amount

    @order         = create_order
    empty_cart

    payment_processor = PaymentProcessor.new(
      current_user.email,
      params[:stripeToken],
      @amount
    )

    if payment_processor.make_payment
      notify_boss
      flash[:success] = "Your payment was successful and your order is placed."
      redirect_to order_path(@order)
    else
      flash[:error] = "There was a problem processing your payment."
      redirect_to cart_path
    end
  end

  private

  def calculate_amount
    total          = cart.total_price * 100
    total.to_i
  end

  def add_events_to_order(id, cart)
    cart.cart_items.each do |cart_item|
      EventOrder.create(order_id:   id,
                        event_id:   cart_item.id,
                        quantity:   cart_item.quantity,
                        unit_price: cart_item.price)
    end
  end

  def create_order
    order = Order.create(user_id: current_user.id,
                 status:  "ordered")

    add_events_to_order(order.id, cart)

    order
  end

  def notify_boss
    client = Twilio::REST::Client.new(ENV["twilio_account_sid"],
                                      ENV["twilio_auth_token"])
    client.messages.create(from: "5005550006",
                           to:   "3039002304",
                           body: "You've received a $#{(@order.total)} order!")
  end

  def empty_cart
    session[:cart] = {}
    cart.clear
  end

end
