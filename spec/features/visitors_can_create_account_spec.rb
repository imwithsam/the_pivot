require "rails_helper"
require "factory_helper"

feature "a visitor can create an account" do
  before do
    build_test_data
    visit root_path
    click_link "Create Account"
  end

  scenario "a visitor clicks on the create account button and" \
    " sees create account form" do
    expect(page).to have_content("First Name")
    expect(page).to have_content("Last Name")
    expect(page).to have_content("Username")
    expect(page).to have_content("Email")
    expect(page).to have_content("Password")
    expect(page).to have_button("Create Account")
  end

  scenario "a visitor fills out and submits a valid create account form" do
    fill_in "First Name", with: "Peter"
    fill_in "Last Name", with: "NickelEater"
    fill_in "Email", with: "peter@doe.com"
    fill_in "Username", with: "Peter's Shop"
    fill_in "Password", with: "password"
    click_button "Create Account"

    within(".alert-success") do
      expect(page).to have_content("Welcome to The Ocho Tickets, Peter NickelEater!")
    end
    within(".navbar-right") do
      expect(page).to have_content("Logged in as Peter NickelEater")
    end
    expect(page).to have_content("Peter")
    expect(page).to have_content("NickelEater")
    expect(page).to have_content("peter@doe.com")
    expect(page).to_not have_content("Login")
    expect(page).to have_content("Logout")
  end

  scenario "a visitor fills out and submits a valid create vendor account form" do
    fill_in "First Name", with: "Peter"
    fill_in "Last Name", with: "NickelEater"
    fill_in "Email", with: "peter@doe.com"
    fill_in "Username", with: "Peter's Shop"
    fill_in "Password", with: "password"
    find("input[type='checkbox'][name*='user[role]']").set(true)
    click_button "Create Account"

    within(".alert-success") do
      expect(page).to have_content("Welcome to The Ocho Tickets, Peter NickelEater!")
    end
    within(".navbar-right") do
      expect(page).to have_content("Logged in as Peter NickelEater")
      expect(page).to have_content("My Store")
    end
    expect(page).to have_content("Peter")
    expect(page).to have_content("NickelEater")
    expect(page).to have_content("peter@doe.com")
    expect(page).to_not have_content("Login")
    expect(page).to have_content("Logout")
  end

  scenario "a visitor fills out and submits an invalid create account form" do
    fill_in "First Name", with: ""
    fill_in "Last Name", with: ""
    fill_in "Email", with: "peter@doe.com"
    fill_in "Username", with: "Peter's Shop"
    fill_in "Password", with: "password"
    click_button "Create Account"

    within(".alert-warning") do
      expect(page).to have_content("First name can't be blank. Last name can't be blank")
    end
  end
end
