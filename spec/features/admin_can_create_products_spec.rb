require "rails_helper"

feature "an admin can create products" do
  before do
    admin = User.create(first_name: "Mike",
                        last_name: "Dorrance",
                        email: "mike@mike.com",
                        password: "12345678",
                        role: "admin")

    visit root_path

    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(admin)

    Category.create(name: "Plants",
                    description: "Plants category description",
                    slug: "plants")
    Category.create(name: "Food",
                    description: "Food category description",
                    slug: "food")

    visit admin_dashboard_path

    click_link "View All Products"
    click_link "Add New Product"
  end

  xscenario "admin visits admin/product/new and sees Add Product Form" do
    expect(page).to have_content("Add a New Product")
    expect(page).to have_content("Name")
    expect(page).to have_content("Description")
    expect(page).to have_content("Price")
    expect(page).to have_content("Category")
    expect(page).to have_content("Status")
    expect(page).to have_content("Image Url")
    expect(page).to have_button("Add Product")
  end

  xscenario "admin can create a new Product" do
    fill_in "Name", with: "Richard Plant"
    fill_in "Description", with: "A boat on a lot."
    fill_in "Price", with: "12.99"
    select "Plants", from: "product[category_id]"
    select "Retired", from: "product[status]"
    fill_in "Image Url", with: "image_url"
    click_button "Add Product"

    within(".alert-success") do
      expect(page).to have_content("Richard Plant has been added.")
    end
    expect(current_path).to eq(admin_dashboard_path)
  end

  xscenario "admin can create a new Product with no image url" do
    fill_in "Name", with: "Richard Plant"
    fill_in "Description", with: "A boat on a lot."
    fill_in "Price", with: "12.99"
    select "Plants", from: "product[category_id]"
    click_button "Add Product"

    visit products_path

    expect(page).to have_css("img[src*='default_image.jpg']")
  end
end
