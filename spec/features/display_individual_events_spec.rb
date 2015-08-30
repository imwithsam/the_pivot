require "rails_helper"
require "factory_helper"

feature "a visitor" do
  context "visits vendor event show pages" do
    before do
      build_test_data
    end

    scenario "and sees product details" do
      visit vendor_event_path(vendor: @event_1.user.url, id: @event_1.id)

      expect(page).to have_content("event 1")
      expect(page).to have_content("event 1 description")
      expect(page).to have_content("25.00")
      expect(page).to have_xpath("//img[@src=\"http://robohash.org/99.png?set=set2&bgset=bg1&size=200x200\"]")

      within(".caption-full") do
        expect(page).to have_xpath(
          "//input[@value=\"Add to Cart\"]")
      end
    end

    scenario "and sees the vendors other events" do
      visit vendor_event_path(vendor: @event_1.user.url, id: @event_1)

      within("#product-carousel") do
        expect(page).to have_content("event 2")
        expect(page).to have_content("50.00")
        expect(page).to have_xpath("//img[@src=\"http://robohash.org/999.png?set=set2&bgset=bg1&size=200x200\"]")
        expect(page).to have_content("event 3")
        expect(page).to have_content("75.00")
        expect(page).to have_xpath("//img[@src=\"http://robohash.org/99.png?set=set2&bgset=bg1&size=200x200\"]")
      end
    end
  end
end
