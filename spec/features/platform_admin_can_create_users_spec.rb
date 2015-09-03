require "rails_helper"

feature "an admin can create events" do
  before do
    build_test_data

    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(@platform_admin_1)

    visit admin_dashboard_path

    click_link "View All Vendors"
    click_link "Create New User"
  end

  scenario "admin visits admin/users/new and sees Create User Form" do
    expect(page).to have_content("First Name")
    expect(page).to have_content("Last Name")
    expect(page).to have_content("Username")
    expect(page).to have_content("Email")
    expect(page).to have_content("Create Vendor Account?")
    expect(page).to have_content("Password")
    expect(page).to have_button("Create Account")
  end

  scenario "admin can create a new registered user" do
    fill_in "First Name", with: "Richard"
    fill_in "Last Name", with: "Boats"
    fill_in "Username", with: "Boater69"
    fill_in "Email", with: "rich@boats.com"
    fill_in "Password", with: "password"
    click_button "Create Account"

    within(".alert-success") do
      expect(page).to have_content("Welcome to The Ocho Tickets, Richard Boats!")
    end
    expect(current_path).to eq(admin_users_path)
  end

  scenario "admin can create a new vendor account" do
    fill_in "First Name", with: "Johnny"
    fill_in "Last Name", with: "Boats"
    fill_in "Username", with: "Boater69"
    fill_in "Email", with: "johnny@boats.com"
    fill_in "Password", with: "password"
    find("input[type='checkbox'][name*='user[role]']").set(true)
    click_button "Create Account"

    expect(current_path).to eq(admin_users_path)
    within(".alert-success") do
      expect(page).to have_content("Welcome to The Ocho Tickets, Johnny Boats!")
    end
    expect(page).to have_content("johnny@boats.com")
  end

  scenario "admin cannot create a new registered user with invalid parameters" do
    fill_in "First Name", with: "Richard"
    fill_in "Last Name", with: "Boater"
    fill_in "Username", with: "Boater69"
    fill_in "Email", with: ""
    fill_in "Password", with: "password"
    click_button "Create Account"

    within(".alert-warning") do
      expect(page).to have_content("Email can't be blank. Email is invalid")
    end
    expect(current_path).to eq(admin_users_path)
  end
end
