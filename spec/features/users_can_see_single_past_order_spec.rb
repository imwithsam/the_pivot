require "rails_helper"
require "factory_helper"

feature "user sees a single past order" do
  context "as an authenticated user with one previous order" do
    before do
      build_products

      @order = Order.create(user_id: @event_1.user.id,
                            status: "ordered",
                            created_at: DateTime.civil(2015, 07, 05, 21, 33, 0),
                            updated_at: DateTime.civil(2015, 07, 05, 21, 33, 0))

      EventOrder.create(order_id: @order.id,
                       event_id: @event_1.id,
                       quantity: 1,
                       unit_price: @event_1.price)

      EventOrder.create(order_id: @order.id,
                       event_id: @event_2.id,
                       quantity: 2,
                       unit_price: @event_2.price)

      allow_any_instance_of(ApplicationController)
        .to receive(:current_user).and_return(@event_1.user)
    end

    scenario "user is able to see past order details" do
      visit dashboard_path

      within("td.order-details-link") do
        click_link("View Order Details")
      end

      expect(current_path).to eq(order_path(@order))

      expect(page).to have_content("Order ID: # #{@order.id}")
      expect(page).to have_content("Purchase Date/Time: July  5, 2015 at  9:33 PM")

      within("tr", text: "event 1") do
        expect(page).to have_content("event 1")
        expect(page).to have_content("1") # qty for Plant1
        expect(page).to have_content("$25.00") # subtotal
        expect(page).to have_xpath("//a[@href=\"#{vendor_event_path(vendor: @event_1.user.url, id: @event_1.id)}\"]")
      end

      within("tr", text: "event 2") do
        expect(page).to have_content("event 2")
        expect(page).to have_content("2") # qty for Plant2
        expect(page).to have_content("$100.00") # subtotal
        expect(page).to have_xpath("//a[@href=\"#{vendor_event_path(vendor: @event_2.user.url, id: @event_2.id)}\"]")
      end

      expect(page).to have_content("ordered", count: 2) # status
      expect(page).to have_content("$100.00") # total
    end

    scenario "if order was completed/cancelled, timestamp is displayed" do
      @order.update(status: "cancelled")
      @order.update(updated_at: DateTime.civil(2015, 8, 2, 21, 33, 0))

      visit order_path(@order)
      within(".other-notes") do
        expect(page).to have_content("This order was cancelled on " \
          "August  2, 2015 at 9:33 PM.")
      end
    end
  end
end
