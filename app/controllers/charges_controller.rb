class ChargesController < ApplicationController
  def create
    total          = cart.total_price
    total_in_cents = total * 100

    # Amount in cents
    @amount        = total_in_cents.to_i

    charge = pay(customer)

    if charge["paid"] == true
      @order = Order.create(user_id: current_user.id,
                            status:  "paid")

      cart.cart_items.each do |cart_item|
        EventOrder.create(order_id:   @order.id,
                          event_id:   cart_item.id,
                          quantity:   cart_item.quantity,
                          unit_price: cart_item.price)
      end

      session[:cart] = {}
      cart.clear

      flash[:success] = "Your payment was successful and your order is placed."
      notify_boss
      redirect_to order_path(@order)
    end


    private

    def notify_boss
      client = Twilio::REST::Client.new(ENV["twilio_account_sid"],
                                        ENV["twilio_auth_token"])
      client.messages.create(from: "5005550006",
                             to:   "3039002304",
                             body: "You've received a $#{(@order.total)} order!")
    end

    def pay
      make_payment

    rescue Stripe::CardError => e
      payment_failed_process(e)
    end
  end

  def make_payment
    Stripe::Charge.create(
      customer:    stripe_customer_id,
      amount:      @amount,
      description: Order.last.id + 1,
      currency:    'usd'
    )
  end

  def payment_failed_process(e)
    flash[:error] = e.message
    redirect_to cart_path
  end

  def stripe_customer_id
    Stripe::Customer.create(
      email: current_user.email,
      card:  params[:stripeToken]
    ).id
  end
end
