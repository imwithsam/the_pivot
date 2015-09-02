require "rails_helper"
require "factory_helper"

feature "Visitor" do
  before { build_test_data }

  context "who is not logged in with an empty cart" do
    scenario "adds one item to cart twice" do
      event = @event_1

      visit vendor_event_path(vendor: event.user.url, id: event.id)
      within(".caption-full") do
        click_button "Add to Cart"
      end

      expect(current_path).to eq vendor_event_path(vendor: event.user.url, id: event.id)
      expect(page).to have_content("added to cart")

      within(".caption-full") do
        click_button "Add to Cart"
      end

      expect(page).to have_content("added to cart")

      find("#cart").click

      expect(current_path).to eq(cart_path)

      within(".name") do
        expect(page).to have_content("event 1")
      end

      within(".row", text: "event 1") do
        quantity = find(".quantity").value
        expect(quantity).to eq("2")
      end

      within(".total") do
        expect(page).to have_content("$50.00")
      end
    end

    scenario "adds two items to the cart" do

      visit vendor_event_path(vendor: @event_1.user.url, id: @event_1.id)
      within(".caption-full") do
        click_button "Add to Cart"
      end
      within(".caption-full") do
        click_button "Add to Cart"
      end

      expect(page).to have_content("added to cart")

      visit vendor_event_path(vendor: @event_2.user.url, id: @event_2.id)
      within(".caption-full") do
        click_button "Add to Cart"
      end

      expect(page).to have_content("added to cart")

      find("#cart").click

      expect(current_path).to eq(cart_path)
      within(".row", text: "event 1") do
        expect(page).to have_content("event 1")
        quantity = find(".quantity").value
        expect(quantity).to eq("2")
        expect(page).to have_content("$50.00")
      end

      within(".row", text: "event 2") do
        expect(page).to have_content("event 2")
        quantity = find(".quantity").value
        expect(quantity).to eq("1")
        expect(page).to have_content("$50.00")
      end
    end

    scenario "adds two items and updates the quantity of one" do
      visit vendor_event_path(vendor: @event_1.user.url, id: @event_1.id)
      within(".caption-full") do
        click_button "Add to Cart"
      end

      visit vendor_event_path(vendor: @event_2.user.url, id: @event_2.id)
      within(".caption-full") do
        click_button "Add to Cart"
      end

      find("#cart").click
      within(".row", text: "event 1") do
        find(".quantity").set("4")
        click_button("update")
      end

      expect(current_path).to eq(cart_path)

      within(".row", text: "event 1") do
        quantity = find(".quantity").value
        expect(quantity).to eq("4")
        expect(page).to have_content("$100.00")
      end

      within(".total") do
        expect(page).to have_content("$150.00")
      end
    end

    scenario "adds an item twice and then decreases the quantity to one" do
      visit vendor_event_path(vendor: @event_1.user.url, id: @event_1.id)
      within(".caption-full") do
        click_button "Add to Cart"
      end
      within(".caption-full") do
        click_button "Add to Cart"
      end

      find("#cart").click
      within(".row", text: "event 1") do
        quantity = find(".quantity").value
        expect(quantity).to eq("2")
        expect(page).to have_content("$50.00")
      end

      within(".total") do
        expect(page).to have_content("$50.00")
      end

      within(".row", text: "event 1") do
        find(".quantity").set("1")
        click_button("update")
      end

      expect(current_path).to eq(cart_path)

      within(".row", text: @event_1.name) do
        quantity = find(".quantity").value
        expect(quantity).to eq("1")
        within(".sub-total") do
          expect(page).to have_content("$25.00")
        end
      end

      within(".total") do
        expect(page).to have_content("$25.00")
      end
    end

    scenario "adds an item and attempts to decrease the quantity negative or zero" do
      visit vendor_event_path(vendor: @event_2.user.url, id: @event_2.id)
      within(".caption-full") do
        click_button "Add to Cart"
      end

      find("#cart").click

      within(".row", text: "event 2") do
        find(".quantity").set("0")
        click_button("update")
      end

      expect(current_path).to eq(cart_path)
      expect(page).to have_content("That's a bold move Cotton! But you can't set quantity below one!")

      within(".row", text: "event 2") do
        quantity = find(".quantity").value
        expect(quantity).to eq("1")
        within(".sub-total") do
          expect(page).to have_content("$50.00")
        end
      end

      within(".row", text: "event 2") do
        find(".quantity").set("-5")
        click_button("update")
      end

      expect(current_path).to eq(cart_path)
      expect(page).to have_content("That's a bold move Cotton! But you can't set quantity below one!")
        quantity = find(".quantity").value
        expect(quantity).to eq("1")
        within(".sub-total") do
          expect(page).to have_content("$50.00")
      end
    end

    scenario "adds an item and then clicks the remove link" do
      visit vendor_event_path(vendor: @event_1.user.url, id: @event_1.id)
      within(".caption-full") do
        click_button "Add to Cart"
      end

      find("#cart").click
      within(".row", text: "event 1") do
        quantity = find(".quantity").value
        expect(quantity).to eq("1")
        expect(page).to have_content("$25.00")
      end

      within(".total") do
        expect(page).to have_content("$25.00")
      end

      within(".row", text: "event 1") do
        click_link("remove")
      end

      expect(current_path).to eq(cart_path)

      within(".flash") do
        expect(page).to have_content("Successfully removed event 1 " \
          "from your cart")
        expect(page).to have_link("event 1")
        expect(page).to have_xpath("//a[@href=\"/#{@event_1.user.url}/events/#{@event_1.id}\"]")
      end

      expect(page).not_to have_content(@event_1.description)

      within(".total") do
        expect(page).not_to have_content("$25.00")
        expect(page).to have_content("$0")
      end
    end
  end
end
