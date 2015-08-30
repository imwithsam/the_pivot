require "rails_helper"
require "factory_helper"

feature "Admin can view all events from Admin Dashboard" do
  before do
    admin = User.create(first_name: "Dave",
                        last_name: "Shim",
                        username: "admin",
                        email: "dave@daveshim.com",
                        password: "password",
                        role: "admin")

    platform_role = Role.create(
      name: "platform_admin"
    )

    admin.roles << platform_role

    build_test_data

    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(admin)

    visit admin_dashboard_path
  end

  scenario "Admin logs in and sees View All Events button" do
    expect(page).to have_content("View All Events")
  end

  scenario "Admin clicks on View All Events and sees all events" do

    click_link "View All Events"

    expect(current_path).to eq(admin_events_path)
    expect(page).to have_content("All Events")
    expect(page).to have_content("Image")
    expect(page).to have_content("Name")
    expect(page).to have_content("Description")
    expect(page).to have_content("Price")
    expect(page).to have_content("Category")
    expect(page).to have_content("Status")

    within("tr", text: @event_1.description) do
      expect(page).to have_css("img[src*='http://robohash.org/99.png?set=set2&bgset=bg1&size=200x200']")
      expect(page).to have_content("event 1")
      expect(page).to have_content("event 1 description")
      expect(page).to have_content("25.00")
      expect(page).to have_content("Sports")
      expect(page).to have_content("active")
      expect(page).to have_link("edit")
    end
  end
  scenario "Admin clicks on edit button and can edit that event" do

    click_link "View All Events"

    within("tr", text: @event_1.description) do
      expect(page).to have_css("img[src*='http://robohash.org/99.png?set=set2&bgset=bg1&size=200x200']")
      expect(page).to have_content("event 1")
      expect(page).to have_content("event 1 description")
      expect(page).to have_content("25.00")
      expect(page).to have_content("Sports")
      expect(page).to have_content("active")
      expect(page).to have_link("edit")

      click_link "edit"
    end

    expect(current_path).to eq(edit_admin_event_path(@event_1))
    expect(page).to have_content("Edit Event")
    expect(page).to have_content("Name")

    name = find("#event_form_name").value
    expect(name).to eq("event 1")

    description = find("#event_form_description").value
    expect(description).to eq("event 1 description")
    expect(page).to have_content("Price")
    price = find("#event_form_price").value
    expect(price).to eq("25.0")
    expect(page).to have_content("Status")
    expect(page).to have_content("Sports")
    expect(page).to have_content("Active")
    expect(page).to have_content("Image Url")
    url = find("#event_form_image_url").value
    expect(url).to eq("http://robohash.org/99.png?set=set2&bgset=bg1&size=200x200")
    expect(page).to have_button("Edit Event")

    find('input[type="text"][name*="name"]').set("Richard")
    find('input[type="text"][name*="description"]').set("A boat.")
    find('input[type="text"][name*="price"]').set("50.00")
    find('input[type="text"][name*="image_url"]').set("")
    select "Music", from: "event[category_id]"
    select "Retired", from: "event[status]"
    click_button "Edit Event"

    expect(current_path).to eq(admin_events_path)
    within("tr", text: "Richard") do
      expect(page).to have_css("img[src*='default_image.jpg']")
      expect(page).to have_content("Richard")
      expect(page).to have_content("A boat.")
      expect(page).to have_content("50.00")
      expect(page).to have_content("Music")
      expect(page).to have_content("inactive")
      expect(page).to have_link("edit")
    end
  end
end
