require "rails_helper"
require "factory_helper"

feature "Store admin can view vendor stores" do
  before do
    build_test_data
    visit root_path
    click_link "Login"

    fill_in "Email", with: @store_admin_1.email
    fill_in "Password", with: @store_admin_1.password
    click_button "Login"
  end

  scenario "store admin can create new events" do
    expect(current_path).to eq(dashboard_path)

    click_link "My Store"
    click_link "Create New Event"

    expect(current_path).to eq(new_vendor_event_path(vendor: @store_admin_1.url))

    fill_in "Name", with: "New Event"
    fill_in "Description", with: "New Description"
    fill_in "Price", with: 1000
    fill_in "Event date", with: "12/15/2019"
    select @cat_2.name, from: "event[category_id]"
    click_button "Add Event"

    expect(page).to have_content("New Event")
    expect(page).to have_content("New Description")
    expect(page).to have_content("$1,000.00")
  end

  scenario "store admin cannot create event with invalid parameters" do
    click_link "My Store"
    click_link "Create New Event"

    expect(current_path).to eq(new_vendor_event_path(vendor: @store_admin_1.url))

    fill_in "Name", with: ""
    fill_in "Description", with: ""
    fill_in "Price", with: ""
    fill_in "Event date", with: ""
    select @cat_2.name, from: "event[category_id]"
    click_button "Add Event"

    expect(current_path).to eq(vendor_events_path(vendor: @store_admin_1.url))
    expect(page).to have_content("Name")
    expect(page).to have_content("Description")
    expect(page).to have_content("Price")
    expect(page).to have_content("Venue")
    expect(page).to have_content("Event date")
    expect(page).to have_content("Category")
    expect(page).to have_content("Status")
    expect(page).to have_content("Image Url")
  end

  scenario "store admin can retire an event" do
    visit vendor_event_path(vendor: @event_1.user.url, id: @event_1.id)

    click_link("Remove Event")

    expect(page).to have_content("Retired")
  end
end
