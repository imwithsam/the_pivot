require "rails_helper"

describe CartItem do
  let(:category) do
    Category.create(name: "Plants",
                    description: "Plants category description",
                    slug: "plants")
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


  it "has a event and a quantity" do
    cart_item = CartItem.new(event, 2)

    expect(cart_item.name).to eq("event 1")
    expect(cart_item.description).to eq("event")
    expect(cart_item.price).to eq(22)

    expect(cart_item.quantity).to be(2)
  end

  context "#item_total" do
    it "returns the quantity times the price" do
      cart_item = CartItem.new(event, 2)

      expect(cart_item.item_total).to eq(44)
    end
  end
end
