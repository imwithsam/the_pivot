require "rails_helper"
require "factory_helper"

feature "User can view vendor stores" do
  before do
    build_test_data
  end

  scenario "registered user visits vendor store page" do
    visit vendors_path
    click_link "Golick's Tickets"

    expect(current_path).to eq("/#{@store_admin_1.url}")
    expect(page).to have_content("golick@example.com")
    expect(page).to have_content("event 2")
    expect(page).to have_content("event 2 description")
    expect(page).to have_content("More Events from Golick's Tickets")
    expect(page).to have_content("event 3")
    expect(page).to have_content("event 3 description")
  end
end
