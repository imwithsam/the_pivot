require "rails_helper"

RSpec.describe Event, type: :model do
  let(:category) do
    Category.create(
      name: "Plants",
      description: "The largest carnivorous plant selection in the world!")
  end

  let(:user) do
    User.create(first_name: "Jane",
                last_name:  "Doe",
                username: "Jane's Shop",
                email:      "jane@doe.com",
                password:   "password")
  end

  let(:event) do
    event = user.events.create(
      name: "event 1" ,
      description: "event",
      image_url: "http://robohash.org/#{Random.new.rand(1..100)}.png?set=set2&bgset=bg1&size=200x200",
      price: 22,
      status: 0,
      venue: "Denver",
      event_date: DateTime.now,
      category_id: category.id)
  end

  it "is created and belongs to a category" do
    expect(event.name).to eq("event 1")
    expect(event.description).to eq("event")
    expect(event.price).to eq(22)

    expect(event.category.name).to eq("Plants")
    expect(event.category.description).to eq(
      "The largest carnivorous plant selection in the world!")
  end

  it "requires a name" do
    event.name = nil

    expect(event).to_not be_valid
  end

  it "requires a unique name" do
    event = user.events.create(
      name: "event 1" ,
      description: "event",
      image_url: "http://robohash.org/#{Random.new.rand(1..100)}.png?set=set2&bgset=bg1&size=200x200",
      price: "22.00",
      status: 0,
      venue: "Denver",
      event_date: DateTime.now,
      category_id: category.id)
      event_2 = user.events.create(
        name: "event 1" ,
        description: "event",
        image_url: "http://robohash.org/#{Random.new.rand(1..100)}.png?set=set2&bgset=bg1&size=200x200",
        price: "22.00",
        status: 0,
        venue: "Denver",
        event_date: DateTime.now,
        category_id: category.id)
    expect(event_2).to_not be_valid
  end

  it "requires a description" do
    event.description = nil

    expect(event).to_not be_valid
  end

  it "requires a price" do
    event.price = nil

    expect(event).to_not be_valid
  end

  it "requires a numeric price" do
    event.price = "abc"

    expect(event).to_not be_valid
  end

  it "requires price to be greater than zero" do
    event.price = "0.00"

    expect(event).to_not be_valid
  end

  it "requires a category" do
    no_category_event = Event.create(
      name: "Venus Fly Trap",
      description: "The gold standard of carnivorous plants!",
      image_url: "venus_fly_trap.jpg",
      price: "19.99")

    expect(no_category_event).to_not be_valid
  end
end
