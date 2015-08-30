require "rails_helper"

feature "a user" do
  let(:category) do
    Category.create(name:        "Plants",
                    description: "Plants category description",
                    slug:        "plants")
  end

  let(:user) do
    User.create(first_name: "Jane",
                last_name:  "Doe",
                username: "Jane's Shop",
                email:      "jane@doe.com",
                password:   "password")
  end

  before do
    user.events.create(
      name: "event 1" ,
      description: "event 1 description",
      image_url: "http://robohash.org/99.png?set=set2&bgset=bg1&size=200x200",
      price: 25.00,
      status: 0,
      venue: "Denver",
      event_date: DateTime.now,
      category_id: category.id)

    user.events.create(
      name: "event 2" ,
      description: "event 2 description",
      image_url: "http://robohash.org/100.png?set=set2&bgset=bg1&size=200x200",
      price: 50.00,
      status: 0,
      venue: "Denver",
      event_date: DateTime.now,
      category_id: category.id)


    @event_3 = user.events.create(
      name: "event 3" ,
      description: "event 3 description",
      image_url: "http://robohash.org/100.png?set=set2&bgset=bg1&size=200x200",
      price: 75.00,
      status: 1,
      venue: "Denver",
      event_date: DateTime.now,
      category_id: category.id)
  end

  scenario "can see all active products" do
    visit events_path

    within(".thumbnail", text: "event 1") do
      expect(page).to have_content("event 1 description")
      expect(page).to have_content("$25.00")
    end
    within(".thumbnail", text: "event 2") do
      expect(page).to have_content("event 2 description")
      expect(page).to have_content("$50.00")
    end
  end

  scenario "cannot see retired events in the events index" do
    visit events_path

    expect(page).not_to have_content("event 3 description")
    expect(page).not_to have_content("$75.00")
  end

  scenario "can access a retired product but cannot add it to the cart" do
    visit event_path(@event_3)

    expect(current_path).to eq vendor_event_path(vendor: @event_3.user.url, id: @event_3.id)
    expect(page).to have_css("input[value*='Retired']")
  end
end
