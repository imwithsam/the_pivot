require "rails_helper"
require "factory_helper"

feature "a store admin can edit events" do
  before do
    build_test_data

    allow_any_instance_of(ApplicationController)
    .to receive(:current_user).and_return(@store_admin_1)

    cart = []
      event = Event.find(@event_1.id)
      cart << event

    unique_vendor_ids = {}

    cart.each do |cart_item|
      unique_vendor_ids[cart_item.user.id] = 0
    end

    unique_vendor_ids.each_key do |vendor_id|
      order = Order.create(
      user_id: vendor_id,
      status:  "ordered",
      customer_id: @user_1.id
      )

      vendors_cart = []

      cart.each do |item|
        if item.user_id.eql?(vendor_id)
          vendors_cart << item
        end
      end

      vendors_cart.each do |vendor_event|
        EventOrder.create(
        order_id:   order.id,
        event_id:   vendor_event.id,
        quantity:   Random.new.rand(1..5),
        unit_price: vendor_event.price
        )
      end
    end
  end

  scenario "user can update the status of an order" do
    visit dashboard_path

    find_link("Cancelled").click

    expect(page).to have_content("Paid")
  end
end
