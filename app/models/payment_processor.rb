class PaymentProcessor
  attr_accessor :customer,
                :card_token,
                :charge

  def initialize(email, card_token, amount)
    @email       = email
    @card_token = card_token
    @amount     = amount
  end

  def make_payment
    @customer = create_stripe_customer
    @charge = create_stripe_charge

    return true

  rescue Stripe::CardError => e
    return false
  end

  private

  def create_stripe_charge
    Stripe::Charge.create(
      customer: @customer.id,
      amount:   @amount,
      currency: 'usd'
    )
  end

  def create_stripe_customer
    Stripe::Customer.create(
      email: @email,
      card:  card_token
    )
  end


end
