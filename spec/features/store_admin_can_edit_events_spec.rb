require "rails_helper"
require "factory_helper"

feature "a store admin can edit events" do
  before do
    build_test_data

    @store_admin_1.events << @event_1
    @store_admin_2.events << @event_2

    visit root_path
    click_link "Login"
    fill_in "Email", with: @store_admin_1.email
    fill_in "Password", with: @store_admin_1.password
    click_button "Login"
  end

  scenario "can view the edit page of his/her own event" do
    visit edit_vendor_event_path(vendor: @store_admin_1.url, id: @event_1.id)

    expect(page).to have_field("event_form_name", with: @event_1.name)
    expect(page).to have_field("event_form_description", with: @event_1.description)
    expect(page).to have_field("event_form_price", with: @event_1.price)
    expect(page).to have_select("event_form_category", selected: @event_1.category.name)
    expect(page).to have_select("event_form_status", selected: @event_1.status.capitalize)
    expect(page).to have_field("event_form_image_url", with: @event_1.image_url)
  end

  scenario "can edit his/her own event" do
    visit edit_vendor_event_path(vendor: @store_admin_1.url, id: @event_1.id)

    fill_in "event_form_name", with: "New Event Name"
    fill_in "event_form_description", with: "New Event Description"
    fill_in "event_form_price", with: "999.99"
    select @cat_2.name, from: "event[category_id]"
    select "Retired", from: "event[status]"
    fill_in "event_form_image_url", with: "New Image Url"
    click_button "Edit Event"

    within(".alert-success") do
      expect(page).to have_content("New Event Name has been updated.")
    end

    visit edit_vendor_event_path(vendor: @store_admin_1.url, id: @event_1.id)

    expect(page).to have_field("event_form_name", with: "New Event Name")
    expect(page).to have_field("event_form_description", with: "New Event Description")
    expect(page).to have_field("event_form_price", with: "999.99")
    expect(page).to have_select("event_form_category", selected: @cat_2.name)
    expect(page).to have_select("event_form_status", selected: "Retired")
    expect(page).to have_field("event_form_image_url", with: "New Image Url")
  end

  scenario "cannot edit his/her own event unless logged in" do
    click_link "Logout"
    visit edit_vendor_event_path(vendor: @store_admin_1.url, id: @event_1.id)

    expect(current_path).to_not eq(
      edit_vendor_event_path(vendor: @store_admin_1.url, id: @event_1.id))
    within(".alert-warning") do
      expect(page).to have_content("Bold move Cotton but you are an unauthorized boat owner!!")
    end
  end

  scenario "cannot edit another admin's event" do
    click_link "Logout"
    click_link "Login"
    fill_in "Email", with: @store_admin_2.email
    fill_in "Password", with: @store_admin_2.password
    click_button "Login"
    visit edit_vendor_event_path(vendor: @store_admin_1.url, id: @event_1.id)

    expect(current_path).to_not eq(
      edit_vendor_event_path(vendor: @store_admin_1.url, id: @event_1.id))
    within(".alert-warning") do
      expect(page).to have_content("That's a bold move Cotton but this is not your boat!")
    end
  end
end
