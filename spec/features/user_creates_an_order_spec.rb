require "rails_helper"

feature "Existing user places an order" do
  context "while logged and with a cart with products" do
    before do
      user = User.create(first_name: "Jane",
                         last_name:  "Doe",
                         email:      "jane@gmail.com",
                         password:   "password")

      category = Category.create(name: "Plants",
                                 description: "Plants category description",
                                 slug: "plants")

      product_1 = category.products.create(name:        "Plant1",
                                           description: "Plant 1 description",
                                           price:       9.99)

      product_2 = category.products.create(name:        "Plant2",
                                           description: "Plant 2 description",
                                           price:       19.99)

      user_cart = Cart.new(nil)
      user_cart.add_item(product_1)
      user_cart.add_item(product_2)

      allow_any_instance_of(ApplicationController)
        .to receive(:current_user).and_return(user)

      allow_any_instance_of(ApplicationController)
        .to receive(:cart).and_return(user_cart)
    end

    xscenario "successfully places an order for two different products" do
      skip
      visit cart_path
      click_button("Checkout")

      expect(current_path).to eq(orders_path)
      within("h1") do
        expect(page).to have_content("Orders")
      end
      expect(page).to have_content("Order was successfully placed!")
      expect(page).to have_content("ordered")
      expect(page).to have_content("$29.98")

      visit cart_path
      expect(current_path).to eq(cart_path)

      expect(page).to_not have_content("Plant1")
      expect(page).to_not have_content("Plant2")
    end
  end

  context "as a visitor, before logging in" do
    xscenario "user is is not able to checkout" do
      visit cart_path

      expect(page).to_not have_link("Checkout")
    end
  end

  context "while logged in with an empty cart" do
    xscenario "user is not able to checkout" do
      user = User.create(first_name: "Jane",
                         last_name:  "Doe",
                         email:      "jane@gmail.com",
                         password:   "password")

      allow_any_instance_of(ApplicationController)
        .to receive(:current_user).and_return(user)

      visit cart_path

      expect(page).to_not have_link("Checkout")
    end
  end
end
