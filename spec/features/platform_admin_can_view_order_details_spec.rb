require "rails_helper"
require "factory_helper"

feature "admin user" do
  scenario "can view individual orders" do
    build_test_data

    @user_1.addresses.create(type_of: "billing",
                          address_1: "1234 Main St", city: "Seattle",
                          state: "WA", zip_code: 98111)

    @user_1.addresses.create(type_of: "shipping",
                          address_1: "5678 South Ave", city: "Seattle",
                          state: "WA", zip_code: 98222)

    order = @user_1.orders.create(status: "ordered",
                       created_at: DateTime.civil(2015, 07, 05, 21, 33, 0),
                       updated_at: DateTime.civil(2015, 07, 05, 21, 33, 0))

    order.event_orders.create(event_id: @event_1.id,
                             quantity:   3,
                             unit_price: @event_1.price)
    order.event_orders.create(event_id: @event_2.id,
                             quantity:   1,
                             unit_price: @event_2.price)

    admin = User.create(first_name: "Dave",
                        last_name:  "S",
                        username: "admin",
                        email:      "dave@dave.com",
                        password:   "password",
                        role:       "admin")


    platform_role = Role.create(
      name: "platform_admin"
    )

    admin.roles << platform_role

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

    within("tr", text: "event 1") do
      expect(page).to have_content("ordered")
      expect(page).to have_content("3")
      expect(page).to have_content("$25.00")
      expect(page).to have_content("$75.00")
    end
    within("tr", text: "event 2") do
      expect(page).to have_content("ordered")
      expect(page).to have_content("1")
      expect(page).to have_content("$50.00")
    end

    expect(page).to have_content("$125.00")
  end
end
