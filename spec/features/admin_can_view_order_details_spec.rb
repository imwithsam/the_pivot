require "rails_helper"
require "factory_helper"

feature "admin user" do
  xscenario "can view individual orders" do
    skip
    category = Category.create(
      name: "Plants",
      description: "Carnivorous plants!"
    )

    plant1 = category.products.create(name: "Plant 1",
                        description: "This is the description for plant 1",
                        price:       19.99,
                        image_url:   "plants/plant-2.jpg",
                        status:      "active")
    plant2 = category.products.create(name: "Plant 2",
                        description: "This is the description for plant 2",
                        price:       29.99,
                        image_url:   "plants/plant-2.jpg",
                        status:      "active")

    user = User.create(first_name: "Jane",
                       last_name:  "Doe",
                       email:      "jane@doe.com",
                       password:   "password")

    user.addresses.create(type_of: "billing",
                          address_1: "1234 Main St", city: "Seattle",
                          state: "WA", zip_code: 98111)

    user.addresses.create(type_of: "shipping",
                          address_1: "5678 South Ave", city: "Seattle",
                          state: "WA", zip_code: 98222)

    order = user.orders.create(status: "ordered",
                       created_at: DateTime.civil(2015, 07, 05, 21, 33, 0),
                       updated_at: DateTime.civil(2015, 07, 05, 21, 33, 0))

    order.order_items.create(product_id: plant1.id,
                             quantity:   3,
                             unit_price: plant1.price)
    order.order_items.create(product_id: plant2.id,
                             quantity:   1,
                             unit_price: plant2.price)

    admin = User.create(first_name: "Mike",
                        last_name:  "D",
                        email:      "mike@mike.com",
                        password:   "12345678",
                        role:       "admin")

    allow_any_instance_of(ApplicationController).to receive(
      :current_user).and_return(admin)

    visit admin_order_path(order)

    expect(current_path).to eq(admin_order_path(order))
    expect(page).to have_content("Order ID: # #{order.id}")
    expect(page).to have_content("Purchase Date/Time: " \
                                 "July  5, 2015 at  9:33 PM")
    expect(page).to have_content("Jane Doe")

    expect(page).to have_content("1234 Main St")
    expect(page).to have_content("98111")

    expect(page).to have_content("5678 South Ave")
    expect(page).to have_content("98222")

    within("tr", text: "Plant 1") do
      expect(page).to have_content("ordered")
      expect(page).to have_content("3")
      expect(page).to have_content("$19.99")
      expect(page).to have_content("$59.97")
    end
    within("tr", text: "Plant 2") do
      expect(page).to have_content("ordered")
      expect(page).to have_content("1")
      expect(page).to have_content("$29.99")
    end

    expect(page).to have_content("$89.96")
  end
end
