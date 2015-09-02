require "rails_helper"
require "factory_helper"

feature "a visitor" do
  before do
    build_test_data
  end

  context "visits /categories/sports" do
    scenario "and sees all sports events" do
      visit root_path
      within("#sports-panel") do
        click_link("Shop Now")
      end

      expect(current_path).to eq(category_path(@cat_1.slug))

      within("h1") do
        expect(page).to have_content("Not Quite Sports")
      end

      within("#category-description") do
        expect(page).to have_content("Stupid Sports")
      end

      expect(page).to have_selector(".thumbnail", count: 3)
      expect(page).to have_content("event 1 u3")
      expect(page).to have_content("25.00")
      expect(page).to have_xpath("//img[@src=\"http://robohash.org/99.png?set=set2&bgset=bg1&size=200x200\"]")
    end
  end

  context "visits /categories/music" do
    scenario "and sees all music events" do
      visit root_path
      within("#music-panel") do
        click_link("Shop Now")
      end

      expect(current_path).to eq(category_path(@cat_2.slug))
      within("h1") do
        expect(page).to have_content("80's German SynthPop")
      end

      within("#category-description") do
        expect(page).to have_content("Horrible Music")
      end

      expect(page).to have_selector(".thumbnail", count: 3)
      expect(page).to have_content("event 2")
      expect(page).to have_content("50.00")
      expect(page).to have_xpath("//img[@src=\"http://robohash.org/999.png?set=set2&bgset=bg1&size=200x200\"]")
    end
  end

  context "visits /categories/accessories" do
    scenario "and sees all accessories" do
      visit root_path
      within("#special-panel") do
        click_link("Shop Now")
      end

      expect(current_path).to eq(category_path(@cat_3.slug))

      within("h1") do
        expect(page).to have_content("Competitive Eating")
      end

      within("#category-description") do
        expect(page).to have_content("Crazy Events")
      end

      expect(page).to have_selector(".thumbnail", count: 3)
      expect(page).to have_content("event 3")
      expect(page).to have_content("75.00")
      expect(page).to have_xpath("//img[@src=\"http://robohash.org/99.png?set=set2&bgset=bg1&size=200x200\"]")
    end
  end
end
