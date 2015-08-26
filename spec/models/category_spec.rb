require "rails_helper"

RSpec.describe Category, type: :model do
  it "can have two products" do
    category = Category.create(
      name: "Plants",
      description: "The largest carnivorous plant selection in the world!")

    user = User.create(first_name: "Jane",
                  last_name:  "Doe",
                  username: "Jane's Shop",
                  email:      "jane@doe.com",
                  password:   "password")

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

    expect(category.name).to eq("Plants")
    expect(category.description).to eq(
      "The largest carnivorous plant selection in the world!")

    expect(user.events.find(event.id).name).to eq("event 1")
    expect(user.events.find(event.id).description).to eq(
      "event")
    expect(user.events.find(event.id).image_url).to eq(
      "http://robohash.org/99.png?set=set2&bgset=bg1&size=200x200",)
    expect(user.events.find(event.id).price).to eq(25)

    expect(user.events.find(event_2.id).name).to eq("event 2")
    expect(user.events.find(event_2.id).description).to eq(
      "event")
    expect(user.events.find(event_2.id).image_url).to eq(
      "http://robohash.org/100.png?set=set2&bgset=bg1&size=200x200")
    expect(user.events.find(event_2.id).price).to eq(50)
  end

  it "requires a name" do
    category = Category.create(
      name: nil,
      description: "The largest carnivorous plant selection in the world!")

    expect(category).to_not be_valid
  end
end
