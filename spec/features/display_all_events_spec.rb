require "rails_helper"
require "factory_helper"

feature "a visitor" do
  context "visits /products" do
    before do
      build_products
    end

    scenario "and sees all products" do
      visit events_path

      expect(page).to have_selector(".thumbnail", count: 9)
      expect(page).to have_content("event 3")
      expect(page).to have_content("25.00")
      expect(page).to have_xpath("//img[@src=\"http://robohash.org/99.png?set=set2&bgset=bg1&size=200x200\"]")
    end
  end
end
