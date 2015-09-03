require "rails_helper"

feature "User can edit User info" do
  before do
    user = User.create(first_name: "Jane",
      last_name:  "Doe",
      username:   "Jane's Shop",
      email:      "jane@doe.com",
      password:   "password")

    user.addresses.create(type_of:   0,
      address_1: "1313 Mockingbird Ln",
      address_2: "Ste 13",
      city:      "Walla Walla",
      state:     "PA",
      zip_code:  "13131")

    user.addresses.create(type_of:   1,
      address_1: "123 Sesame St",
      address_2: "Apt 123",
      city:      "New York",
      state:     "NY",
      zip_code:  "12345")

    reg_user_role = Role.create(name: "registered_user")
    Role.create(name: "store_admin")
    user.roles << reg_user_role

    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)

    visit dashboard_path
    click_link "Edit Account"
  end

  scenario "views edit form and updates Login Info" do
    within("#login-info") do
      expect(find_field("user_first_name").value).to eq("Jane")
      expect(find_field("user_last_name").value).to eq("Doe")
      expect(find_field("user_email").value).to eq("jane@doe.com")
      expect(has_checked_field?("user_role")).to eq(false)
    end

    within("#billing-info") do
      expect(find_field("address_address_1").value).to eq("1313 Mockingbird Ln")
      expect(find_field("address_address_2").value).to eq("Ste 13")
      expect(find_field("address_city").value).to eq("Walla Walla")
      expect(find_field("address_state").value).to eq("PA")
      expect(find_field("address_zip_code").value).to eq("13131")
    end

    within("#shipping-info") do
      expect(find_field("address_address_1").value).to eq("123 Sesame St")
      expect(find_field("address_address_2").value).to eq("Apt 123")
      expect(find_field("address_city").value).to eq("New York")
      expect(find_field("address_state").value).to eq("NY")
      expect(find_field("address_zip_code").value).to eq("12345")
    end
  end

  scenario "updates Login Info" do
    within("#login-info") do
      find('input[type="text"][name*="user[first_name]"]').set("John")
      find('input[type="text"][name*="user[last_name]"]').set("Doh")
      find('input[type="text"][name*="user[email]"]').set("john@doh.com")
      find('input[type="password"][name*="user[password]"]').set("password")
      click_button "Update Login Info"
    end

    within(".alert-success") do
      expect(page).to have_content("Your account has been updated.")
    end

    expect(find_field("user_first_name").value).to eq("John")
    expect(find_field("user_last_name").value).to eq("Doh")
    expect(find_field("user_email").value).to eq("john@doh.com")
    expect(has_checked_field?("user_role")).to eq(false)
  end

  scenario "updates to vendor account" do
    within("#login-info") do
      find('input[type="password"][name*="user[password]"]').set("password")
      find('input[type="checkbox"][name*="user[role]"]').set(true)
      click_button "Update Login Info"
    end

    within(".alert-success") do
      expect(page).to have_content("Your account has been updated.")
    end

    expect(find_field("user_first_name").value).to eq("Jane")
    expect(find_field("user_last_name").value).to eq("Doe")
    expect(find_field("user_email").value).to eq("jane@doe.com")
    expect(page).to_not have_content("Create Vendor Account?")
  end

  scenario "updates Login Info with invalid parameters" do
    within("#login-info") do
      find('input[type="text"][name*="user[first_name]"]').set("")
      find('input[type="text"][name*="user[last_name]"]').set("")
      find('input[type="text"][name*="user[email]"]').set("")
      find('input[type="password"][name*="user[password]"]').set("password")
      find('input[type="checkbox"][name*="user[role]"]').set(true)
      click_button "Update Login Info"
    end

    within(".alert-warning") do
      expect(page).to have_content("First name can't be blank. Last name can't be blank. Email can't be blank. Email is invalid")
    end
  end

  scenario "updates Login Info with invalid password" do
    within("#login-info") do
      find('input[type="text"][name*="user[first_name]"]').set("")
      find('input[type="text"][name*="user[last_name]"]').set("Doh")
      find('input[type="text"][name*="user[email]"]').set("john@doh.com")
      find('input[type="password"][name*="user[password]"]').set("")
      find('input[type="checkbox"][name*="user[role]"]').set(true)
      click_button "Update Login Info"
    end

    within(".alert-warning") do
      expect(page).to have_content("Invalid password. Please re-enter to update your login info.")
    end
  end

  scenario "updates Billing Address" do
    within("#billing-info") do
      find('input[type="text"][name*="address[address_1]"]').set("1 Billing Address Way")
      find('input[type="text"][name*="address[address_2]"]').set("Unit 2")
      find('input[type="text"][name*="address[city]"]').set("Arlington")
      find('input[type="text"][name*="address[state]"]').set("TX")
      find('input[type="text"][name*="address[zip_code]"]').set("76014")
      click_button "Update Billing Address"
    end

    within(".alert-success") do
      expect(page).to have_content("Your address has been updated.")
    end

    within("#billing-info") do
      expect(find_field("address_address_1").value).to eq("1 Billing Address Way")
      expect(find_field("address_address_2").value).to eq("Unit 2")
      expect(find_field("address_city").value).to eq("Arlington")
      expect(find_field("address_state").value).to eq("TX")
      expect(find_field("address_zip_code").value).to eq("76014")
    end
  end

  scenario "updates Shipping Address" do
    within("#shipping-info") do
      find('input[type="text"][name*="address[address_1]"]').set("2 Shipping Address Pl")
      find('input[type="text"][name*="address[address_2]"]').set("#5")
      find('input[type="text"][name*="address[city]"]').set("Denver")
      find('input[type="text"][name*="address[state]"]').set("CO")
      find('input[type="text"][name*="address[zip_code]"]').set("80223")
      click_button "Update Shipping Address"
    end

    within(".alert-success") do
      expect(page).to have_content("Your address has been updated.")
    end

    within("#shipping-info") do
      expect(find_field("address_address_1").value).to eq("2 Shipping Address Pl")
      expect(find_field("address_address_2").value).to eq("#5")
      expect(find_field("address_city").value).to eq("Denver")
      expect(find_field("address_state").value).to eq("CO")
      expect(find_field("address_zip_code").value).to eq("80223")
    end
  end

  scenario "cannot update while not logged in" do
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(nil)

    visit account_edit_path

    within(".alert-warning") do
      expect(page).to have_content("That's a bold move Cotton. Please log in.")
    end
  end

  scenario "receives error after submitting Login Info with invalid password" do
    within("#login-info") do
      find('input[type="text"][name*="user[first_name]"]').set("John")
      find('input[type="text"][name*="user[last_name]"]').set("Doh")
      find('input[type="text"][name*="user[email]"]').set("john@doh.com")
      find('input[type="password"][name*="user[password]"]').set("password1")
      find('input[type="checkbox"][name*="user[role]"]').set(true)
      click_button "Update Login Info"
    end

    within(".alert-warning") do
      expect(page).to have_content(
      "Invalid password. Please re-enter to update your login info.")
    end
    expect(find_field("user_first_name").value).to eq("Jane")
    expect(find_field("user_last_name").value).to eq("Doe")
    expect(find_field("user_email").value).to eq("jane@doe.com")
    expect(has_checked_field?("user_role")).to eq(false)
  end

  scenario "receives error after submitting invalid Login Info with correct password" do
    within("#login-info") do
      find('input[type="text"][name*="user[first_name]"]').set("")
      find('input[type="text"][name*="user[last_name]"]').set("")
      find('input[type="text"][name*="user[email]"]').set("")
      find('input[type="password"][name*="user[password]"]').set("password")
      click_button "Update Login Info"
    end

    within(".alert-warning") do
      expect(page).to have_content("First name can't be blank")
      expect(page).to have_content("Last name can't be blank")
      expect(page).to have_content("Email can't be blank")
      expect(page).to have_content("Email is invalid")
    end
  end

  scenario "receives error after submitting invalid Billing Address data" do
    within("#billing-info") do
      find('input[type="text"][name*="address[address_1]"]').set("")
      find('input[type="text"][name*="address[city]"]').set("")
      find('input[type="text"][name*="address[state]"]').set("")
      find('input[type="text"][name*="address[zip_code]"]').set("")
      click_button "Update Billing Address"
    end

    within(".alert-warning") do
      expect(page).to have_content("Address 1 can't be blank")
      expect(page).to have_content("City can't be blank")
      expect(page).to have_content("State can't be blank")
      expect(page).to have_content("Zip code can't be blank")
      expect(page).to have_content("Zip code is not a number")
      expect(page).to have_content("Zip code is too short")
    end
  end

  scenario "receives error after submitting invalid Shipping Address data" do
    within("#shipping-info") do
      find('input[type="text"][name*="address[address_1]"]').set("")
      find('input[type="text"][name*="address[city]"]').set("")
      find('input[type="text"][name*="address[state]"]').set("")
      find('input[type="text"][name*="address[zip_code]"]').set("")
      click_button "Update Shipping Address"
    end

    within(".alert-warning") do
      expect(page).to have_content("Address 1 can't be blank")
      expect(page).to have_content("City can't be blank")
      expect(page).to have_content("State can't be blank")
      expect(page).to have_content("Zip code can't be blank")
      expect(page).to have_content("Zip code is not a number")
      expect(page).to have_content("Zip code is too short")
    end
  end
end
