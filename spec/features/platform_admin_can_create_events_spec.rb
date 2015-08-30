require "rails_helper"

feature "an admin can create events" do
  before do
    admin = User.create(first_name: "Dave",
                        last_name: "Shim",
                        username: "Dave's Shop",
                        email: "dave@daveshim.com",
                        password: "password",
                        role: "admin")

    platform_role = Role.create(
      name: "platform_admin"
    )

    admin.roles << platform_role


    visit root_path

    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(admin)

    Category.create(name: "Sports",
                    description: "Sports category description",
                    slug: "sports")
    Category.create(name: "Food",
                    description: "Food category description",
                    slug: "food")

    visit admin_dashboard_path

    click_link "View All Events"
    click_link "Add New Event"
  end

    scenario "admin visits admin/product/new and sees Add Product Form" do
    expect(page).to have_content("Add a New Event")
    expect(page).to have_content("Name")
    expect(page).to have_content("Description")
    expect(page).to have_content("Price")
    expect(page).to have_content("Category")
    expect(page).to have_content("Status")
    expect(page).to have_content("Image Url")
    expect(page).to have_button("Add Event")
  end

  scenario "admin can create a new Product" do
    fill_in "Name", with: "Richard Plant Event"
    fill_in "Description", with: "A boat on a lot."
    fill_in "Price", with: "12.99"
    select "Sports", from: "event[category_id]"
    select "Retired", from: "event[status]"
    fill_in "Image Url", with: "image_url"
    click_button "Add Event"

    within(".alert-success") do
      expect(page).to have_content("Richard Plant Event has been added.")
    end
    expect(current_path).to eq(admin_dashboard_path)
  end

  scenario "admin can create a new event with no image url" do
    fill_in "Name", with: "Richard Plant"
    fill_in "Description", with: "A boat on a lot."
    fill_in "Price", with: "12.99"
    select "Sports", from: "event[category_id]"
    click_button "Add Event"

    visit events_path

    expect(page).to have_css("img[src*='default_image.jpg']")
  end
end
