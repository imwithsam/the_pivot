require "rails_helper"

feature "Existing user places an order" do
  context "while logged and with a cart with products" do
    before do

      user = User.create(first_name: "Jane",
                         last_name:  "Doe",
                         username: "Jane's Shop",
                         email:      "jane@gmail.com",
                         password:   "password")

      category = Category.create(name: "Plants",
                                 description: "Plants category description",
                                 slug: "plants")

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

      user_cart = Cart.new(nil)
      user_cart.add_item(event)
      user_cart.add_item(event_2)

      allow_any_instance_of(ApplicationController)
        .to receive(:current_user).and_return(user)

      allow_any_instance_of(ApplicationController)
        .to receive(:cart).and_return(user_cart)
    end

    xscenario "successfully places an order for two different products" do
      visit cart_path
      click_button("Checkout")

      # save_and_open_page
      expect(current_path).to eq(orders_path)
      within("h1") do
        expect(page).to have_content("Orders")
      end
      expect(page).to have_content("Order was successfully placed!")
      expect(page).to have_content("ordered")
      expect(page).to have_content("$25.00")

      visit cart_path
      expect(current_path).to eq(cart_path)

      expect(page).to_not have_content("event 1")
      expect(page).to_not have_content("event 2")
    end
  end

  context "as a visitor, before logging in" do
    scenario "user is is not able to checkout" do
      visit cart_path

      expect(page).to_not have_link("Checkout")
    end
  end

  context "while logged in with an empty cart" do
    scenario "user is not able to checkout" do
      user = User.create(first_name: "Jane",
                         last_name:  "Doe",
                         username: "Jane's Shop",
                         email:      "jane@gmail.com",
                         password:   "password")

      allow_any_instance_of(ApplicationController)
        .to receive(:current_user).and_return(user)

      visit cart_path

      expect(page).to_not have_link("Checkout")
    end
  end
end
