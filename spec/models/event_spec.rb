require "rails_helper"

RSpec.describe Event, type: :model do
  let(:category) do
    Category.create(
      name: "Plants",
      description: "The largest carnivorous plant selection in the world!")
  end

  let(:event) do
    event = user.events.create(
      name: "event 1" ,
      description: "event",
      image_url: "http://robohash.org/#{i}.png?set=set2&bgset=bg1&size=200x200",
      price: "22.00",
      status: 0,
      venue: "Denver",
      event_date: Datetime.now,
      category_id: Random.new.rand(1..25))
  end

  it "is created and belongs to a category" do
    expect(event.name).to eq("Venus Fly Trap")
    expect(event.description).to eq(
      "The gold standard of carnivorous plants!")
    expect(event.image_url).to eq("venus_fly_trap.jpg")
    expect(event.price).to eq(19.99)

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
      image_url: "http://robohash.org/#{i}.png?set=set2&bgset=bg1&size=200x200",
      price: "22.00",
      status: 0,
      venue: "Denver",
      event_date: Datetime.now,
      category_id: Random.new.rand(1..25))
      event = user.events.create(
        name: "event 1" ,
        description: "event",
        image_url: "http://robohash.org/#{i}.png?set=set2&bgset=bg1&size=200x200",
        price: "22.00",
        status: 0,
        venue: "Denver",
        event_date: Datetime.now,
        category_id: Random.new.rand(1..25))
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
