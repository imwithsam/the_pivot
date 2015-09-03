require "rails_helper"

describe Cart do
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

  context "#cart_items" do
    it "returns an array of CartItems" do
      data = Hash.new(0)
      data[event.id] = 2
      cart = Cart.new(data)

      expect(cart.cart_items.first).to be_a_kind_of(CartItem)
    end
  end

  context "#items" do
    it "returns an array of Products" do
      data = Hash.new(0)
      data[event.id] = 2
      cart = Cart.new(data)

      expect(cart.items.first).to be_a_kind_of(Event)
    end
  end

  context "#data" do
    it "returns a hash with the event id and quantity" do
      input_data = {}
      input_data[event.id.to_s] = 2
      cart = Cart.new(input_data)

      expect(cart.data).to eq(event.id.to_s => 2)
    end
  end

  context "#add_item" do
    it "updates the data method when a event is added" do
      cart = Cart.new(nil)
      cart.add_item(event)
      expect(cart.data).to eq(event.id.to_s => 1)

      cart.add_item(event)
      expect(cart.data).to eq(event.id.to_s => 2)
    end
  end

  context "#update_item_quantity" do
    it "updates the data method when a event is added" do
      input_data = {}
      input_data[event.id.to_s] = 2
      cart = Cart.new(input_data)

      expect(cart.data).to eq(event.id.to_s => 2)

      cart.update_item_quantity(event, 4)
      expect(cart.data).to eq(event.id.to_s => 4)
    end
  end

  context "#delete_item" do
    it "removes the event from data" do
      input_data = {}
      input_data[event.id.to_s] = 2
      cart = Cart.new(input_data)

      expect(cart.data).to eq(event.id.to_s => 2)

      cart.delete_item(event)
      expect(cart.data).to eq({})
    end

    it "removes the event from data using the clear method" do
      input_data = {}
      input_data[event.id.to_s] = 2
      cart = Cart.new(input_data)

      expect(cart.data).to eq(event.id.to_s => 2)

      cart.clear
      expect(cart.data).to eq({})
    end
  end

  context "#total_price" do
    it "returns the total price for the cart" do
      cart = Cart.new(nil)
      cart.add_item(event)
      cart.add_item(event)

      expect(cart.total_price).to eq(44)
    end
  end
end
