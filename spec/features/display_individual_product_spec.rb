require "rails_helper"

feature "a visitor" do
  context "visits /products/:id" do
    let(:category) do
      Category.create(name: "Plants",
                      description: "Plants category description",
                      slug: "plants")
    end

    let(:product) do
      category.products.create(
        name: "Plant 1",
        description: "This is the description for plant 1",
        price: 19.99,
        image_url: "plants/plant-2.jpg")
    end

    xscenario "and sees product details" do
      visit product_path(product)

      expect(page).to have_content("Plant 1")
      expect(page).to have_content("This is the description for plant 1")
      expect(page).to have_content("19.99")
      expect(page).to have_xpath("//img[@src=\"/assets/plants/plant-2.jpg\"]")

      within(".caption-full") do
        expect(page).to have_xpath(
          "//input[@value=\"Add to Cart\"]")
      end
    end

    xscenario "and sees featured products" do
      category.products.create(
        name: "Plant 2",
        description: "This is the description for plant 2",
        price: 29.99,
        image_url: "plants/plant-4.jpg")
      category.products.create(
        name: "Plant 3",
        description: "This is the description for plant 3",
        price: 39.99,
        image_url: "plants/plant-3.jpg")

      visit product_path(product)

      within("#product-carousel") do
        expect(page).to have_content("Plant 1")
        expect(page).to have_content("19.99")
        expect(page).to have_xpath("//img[@src=\"/assets/plants/plant-2.jpg\"]")
        expect(page).to have_content("Plant 2")
        expect(page).to have_content("29.99")
        expect(page).to have_xpath("//img[@src=\"/assets/plants/plant-4.jpg\"]")
        expect(page).to have_content("Plant 3")
        expect(page).to have_content("39.99")
        expect(page).to have_xpath("//img[@src=\"/assets/plants/plant-3.jpg\"]")
      end
    end
  end
end
