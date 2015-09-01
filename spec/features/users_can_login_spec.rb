require "rails_helper"
require "factory_helper"

feature "a user can login" do
  scenario "an existing user logs in" do
    User.create(first_name: "Jane",
                last_name: "Doe",
                username: "Jane's Shop",
                email: "jane@doe.com",
                password: "12345678")

    visit root_path
    click_link "Login"

    expect(current_path).to eq(login_path)
    expect(page).to have_content("Welcome Back to The Ocho Tickets!")
    expect(page).to have_content("Email")
    expect(page).to have_content("Password")
    expect(page).to have_button("Login")

    fill_in "Email", with: "jane@doe.com"
    fill_in "Password", with: "12345678"
    click_button "Login"

    expect(current_path).to eq(dashboard_path)
    within(".alert-success") do
      expect(page).to have_content("Welcome back to The Ocho Tickets, Jane Doe!")
    end
    within(".navbar-right") do
      expect(page).to have_link("Logged in as Jane Doe")
    end
    expect(page).to have_content("Jane")
    expect(page).to have_content("Doe")
    expect(page).to have_content("jane@doe.com")
    expect(page).to_not have_content("Login")
    expect(page).to have_content("Logout")
  end

  scenario "a visitor without an account can not login" do
    visit root_path
    click_link "Login"

    expect(current_path).to eq(login_path)
    expect(page).to have_content("Welcome Back to The Ocho Tickets!")
    expect(page).to have_content("Email")
    expect(page).to have_content("Password")
    expect(page).to have_button("Login")

    fill_in "Email", with: "jane@doe.com"
    fill_in "Password", with: "12345678"
    click_button "Login"

    expect(current_path).to eq(login_path)
    within(".alert-warning") do
      expect(page).to have_content("Unable to Login with this Email and" \
        " Password combination.")
    end
    within(".navbar-right") do
      expect(page).to_not have_content("Logged in as Jane Doe")
    end
    expect(page).to_not have_content("Jane")
    expect(page).to_not have_content("Doe")
    expect(page).to_not have_content("jane@doe.com")
    expect(page).to have_content("Create Account")
    expect(page).to have_content("Login")
  end

  scenario "an existing user with events in cart logs in" do
    build_test_data
    event = @event_1

    visit vendor_event_path(vendor: event.user.url, id: event.id)
    within(".caption-full") do
      click_button "Add to Cart"
    end

    find("#cart").click
    expect(current_path).to eq(cart_path)

    click_link_or_button "Checkout"
    expect(current_path).to eq(login_path)

    fill_in "Email", with: @user_1.email
    fill_in "Password", with: "password"
    click_button "Login"

    expect(current_path).to eq(cart_path)
  end
end
