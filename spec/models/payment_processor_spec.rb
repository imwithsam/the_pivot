require "rails_helper"
require "stripe_mock"

RSpec.describe PaymentProcessor, type: :model do
  let(:user_email) { "macho@man.savage" }
  let(:stripe_helper) { StripeMock.create_test_helper }
  let(:fake_token) { stripe_helper.generate_card_token }
  let(:amount) { 1223 }
  let(:pp) { PaymentProcessor.new(user_email, fake_token, amount) }

  before do
    # This is a hack because we are currently setting the key in a js call
    # need to refactor out the api keys to evn variables
    Stripe.api_key = 'pk_test_Sc54Tr3cr3BehQcnGzyCz5xu'
    StripeMock.start
  end

  after do
    StripeMock.stop
  end

  it "creates a stripe customer" do

    pp.make_payment

    expect(pp.customer.email).to eq(user_email)
    expect(pp.customer.card).to eq(fake_token)
  end

  it "creates charge for the customer" do

    pp.make_payment

    expect(pp.charge.customer).to eq(pp.customer.id)
    expect(pp.charge.amount).to eq(amount)
    expect(pp.charge.currency).to eq('usd')
  end

  it "returns true if payment successfull" do
    expect(pp.make_payment).to eq(true)
  end

  it "returns false if payment not successful" do
    StripeMock.prepare_card_error(:card_declined)

    expect(pp.make_payment).to eq(false)
  end
end
