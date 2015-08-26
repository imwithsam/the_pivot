require "rails_helper"

RSpec.describe Order, type: :model do
  before do
    user = User.create(first_name: "Jane",
                       last_name:  "Doe",
                       username: "Jane's Shop",
                       email:      "jane@doe.com",
                       password:   "password")

    @order = user.orders.create(status: "ordered")

    category = Category.create(
      name: "Plants",
      description: "The largest carnivorous plant selection in the world!")

    event = user.events.create(
      name: "event 1" ,
      description: "event",
      image_url: "http://robohash.org/99.png?set=set2&bgset=bg1&size=200x200",
      price: 25,
      status: 0,
      venue: "Denver",
      event_date: DateTime.now,
      category_id: category.id)

    event_2 = user.events.create(
      name: "event 2" ,
      description: "event",
      image_url: "http://robohash.org/100.png?set=set2&bgset=bg1&size=200x200",
      price: 50,
      status: 0,
      venue: "Denver",
      event_date: DateTime.now,
      category_id: category.id)

    EventOrder.create(order_id: @order.id,
                     event_id: event.id,
                     quantity: 2,
                     unit_price: 25.00)

    EventOrder.create(order_id: @order.id,
                     event_id: event_2.id,
                     quantity: 1,
                     unit_price: 50.00)
  end

  it "belongs to a user" do
    expect(@order.user.first_name).to eq("Jane")
  end

  it "is valid with a status of ordered" do
    expect(@order.status).to eq("ordered")
    expect(@order).to be_valid
  end

  it "is valid with a status of paid" do
    @order.status = "paid"
    expect(@order).to be_valid
  end

  it "is valid with a status of cancelled" do
    @order.status = "cancelled"
    expect(@order).to be_valid
  end

  it "is valid with a status of completed" do
    @order.status = "completed"
    expect(@order).to be_valid
  end

  it "is invalid with a blank status" do
    @order.status = ""
    expect(@order).to be_invalid
  end

  it "is invalid with a nil status" do
    @order.status = nil
    expect(@order).to be_invalid
  end

  it "is invalid with a whatever status" do
    expect { @order.status = "whatever" }.to raise_error(ArgumentError)
  end

  it "has a created_at and updated_at" do
    expect(@order.created_at).to be_a_kind_of(ActiveSupport::TimeWithZone)
    expect(@order.updated_at).to be_a_kind_of(ActiveSupport::TimeWithZone)
  end

  it "has many order items" do
    expect(@order.event_orders.first.quantity).to eq(2)
    expect(@order.event_orders.last.quantity).to eq(1)
  end

  it "returns the correct #total for an order" do
    expect(@order.total).to eq(100.00)
  end

  it "returns cancel and completed for #available_status_transitions if status is paid" do
    @order.status = "paid"

    expect(@order.available_status_transitions).to eq(["cancelled", "completed"])
  end

  it "returns cancel and paid for #available_status_transitions if status is ordered" do
    @order.status = "ordered"

    expect(@order.available_status_transitions).to eq(["cancelled", "paid"])
  end

  it "returns an empty array for #available_status_transitions if status is cancelled or completed" do
    @order.status = "cancelled"
    expect(@order.available_status_transitions).to eq([])

    @order.status = "completed"
    expect(@order.available_status_transitions).to eq([])
  end
end
