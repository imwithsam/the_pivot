require "rails_helper"

feature "a user" do
  let(:category) do
    Category.create(name:        "Plants",
                    description: "Plants category description",
                    slug:        "plants")
  end

  before do
    category.products.create(
                 name:        "Plant 1",
                 description: "This is the description for plant 1",
                 price:       19.99,
                 image_url:   "plants/plant-2.jpg",
                 status:      "active")
    category.products.create(
                 name:        "Plant 2",
                 description: "This is the description for plant 2",
                 price:       29.99,
                 image_url:   "plants/plant-3.jpg",
                 status:      "active")
    @plant3 = category.products.create(
                 name:        "Plant 3",
                 description: "This is the description for plant 3",
                 price:       39.99,
                 image_url:   "plants/venus-fly-traps.jpg",
                 status:      "inactive")
  end

  xscenario "can see all active products" do
    visit products_path

    within(".thumbnail", text: "Plant 1") do
      expect(page).to have_content("This is the description for plant 1")
      expect(page).to have_content("$19.99")
    end
    within(".thumbnail", text: "Plant 2") do
      expect(page).to have_content("This is the description for plant 2")
      expect(page).to have_content("$29.99")
    end
  end

  xscenario "cannot see retired products in the products index" do
    visit products_path

    expect(page).not_to have_content("This is the description for plant 3")
    expect(page).not_to have_content("$39.99")
  end

  xscenario "can access a retired product but cannot add it to the cart" do
    visit product_path(@plant3)

    expect(current_path).to eq product_path(@plant3)
    expect(page).to have_css("input[value*='Retired']")
  end
end
