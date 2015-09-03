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

  scenario "Admin logs in and sees View All Vendors button" do
    expect(page).to have_content("View All Vendors")
  end

  scenario "Admin clicks on View All Vendors and sees all vendors" do

    click_link "View All Vendors"

    expect(current_path).to eq(admin_users_path)
    expect(page).to have_content("All Vendors")
    expect(page).to have_content("Store Name")
    expect(page).to have_content("Vendor Name")
    expect(page).to have_content("Vendor Email")
    expect(page).to have_content("Update Vendor")

  end
  scenario "Admin clicks on edit button and can edit that vendor" do

    click_link "View All Vendors"
    first(:link, "Update").click

    expect(current_path).to eq(edit_admin_user_path(@store_admin_1.id))

    fill_in "Store Name", with: "Johnny's Shop"
    fill_in "Vendor Name", with: "Johnny Bobson"
    fill_in "Email", with: "j@bob.com"
    fill_in "Password", with: "password"
    click_button "Update Login Info"

    visit admin_users_path

    expect(page).to have_content("Johnny's Shop")
    expect(page).to have_content("j@bob.com")
  end

  scenario "Admin clicks on edit button and cannot edit with no password" do

    click_link "View All Vendors"
    first(:link, "Update").click

    expect(current_path).to eq(edit_admin_user_path(@store_admin_1.id))

    fill_in "Store Name", with: "Johnny's Shop"
    fill_in "Vendor Name", with: "Johnny Bobson"
    fill_in "Email", with: "j@bob.com"
    click_button "Update Login Info"

    expect(page).to have_content("Invalid password. Please re-enter to update your login info.")
  end

  scenario "Admin clicks on edit button and cannot edit with no email" do

    click_link "View All Vendors"
    first(:link, "Update").click

    expect(current_path).to eq(edit_admin_user_path(@store_admin_1.id))

    fill_in "Email", with: ""
    fill_in "Password", with: "password"
    click_button "Update Login Info"

    expect(page).to have_content("Email can't be blank. Email is invalid")
  end

  scenario "Admin can remove vendor functionality from user accounts" do

    click_link "View All Vendors"

    expect(current_path).to eq(admin_users_path)
    expect(page).to have_content("All Vendors")
    expect(page).to have_content("Store Name")
    expect(page).to have_content("Vendor Name")
    expect(page).to have_content("Vendor Email")
    expect(page).to have_content("Update Vendor")

    first(:link, "Delete").click

    expect(current_path).to eq(admin_users_path)
    expect(page).to_not have_content("Golick's Tickets")
    expect(page).to_not have_content("James Golick")
    expect(page).to_not have_content("golick@example.com")

  end

  scenario "Admin clicks on edit button and can edit that vendor's address" do

    click_link "View All Vendors"
    first(:link, "Update").click

    fill_in "Address 1", with: "456 Fake Street"
    fill_in "Address 2", with: "Apt 999"
    fill_in "City", with: "Vail"
    fill_in "State", with: "CO"
    fill_in "Zip code", with: "90210"
    click_button "Update Billing Address"

    expect(page).to have_field("Address 1", with: "456 Fake Street")
    expect(page).to have_field("Address 2", with: "Apt 999")
  end

  scenario "Admin clicks on edit button and can edit that vendor's address" do

    click_link "View All Vendors"
    first(:link, "Update").click

    fill_in "Address 1", with: ""
    fill_in "Address 2", with: ""
    fill_in "City", with: ""
    fill_in "Zip code", with: "90210"
    click_button "Update Billing Address"

    expect(page).to have_content("Address 1 can't be blank. City can't be blank")
  end
end
