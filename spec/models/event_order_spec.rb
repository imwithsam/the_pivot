require "rails_helper"

RSpec.describe EventOrder, type: :model do
  before do
    user = User.create(first_name: "Jane",
                       last_name:  "Doe",
                       email:      "jane@doe.com",
                       password:   "password")

    order = Order.create(user_id: user.id,
                         status: "ordered")

    category = Category.create(
      name: "Plants",
      description: "The largest carnivorous plant selection in the world!")

    event = user.events.create(
      name: "event 1" ,
      description: "event",
      image_url: "http://robohash.org/#{i}.png?set=set2&bgset=bg1&size=200x200",
      price: "22.00",
      status: 0,
      venue: "Denver",
      event_date: Datetime.now,
      category_id: Random.new.rand(1..25)

      )

    @event_order = EventOrder.create(order_id: order.id,
                                   event_id: event.id,
                                   quantity: 1,
                                   unit_price: 22.00)
  end

  it "belongs to an order" do
    expect(@event_order.order.status).to eq("ordered")
  end

  it "has a quantity" do
    expect(@event_order.quantity).to eq(1)
  end

  it "has a unit_price" do
    expect(@event_order.unit_price).to eq(19.99)
  end

  it "has a created_at and updated_at" do
    expect(@event_order.created_at).to be_a_kind_of(ActiveSupport::TimeWithZone)
    expect(@event_order.updated_at).to be_a_kind_of(ActiveSupport::TimeWithZone)
  end

  it "cant have a quantity of zero" do
    @event_order.update(quantity: 0)
    expect(@event_order).to be_invalid
  end

  it "cant have a negative quantity" do
    @event_order.update(quantity: -5)
    expect(@event_order).to be_invalid
  end
end
