require "rails_helper"

feature "user can visit events" do
  scenario "user can view featured events" do
    vendor = User.create(username: "Ticket Co.", first_name: "Sam", last_name: "Wright", email: "ticket@ticket.com", password: "password")
    category = Category.create(name: "Stupid Sports", description: "blah" )
    event = vendor.events.create(name: "Tazer Ball", description: "Taze people with balls", image_url: "/events/soil.jpg", price: 100, venue: "Pepsi Center", event_date: "12/12/2015", category_id: category.id)

    visit root_path

    expect(page).to have_content("Featured Events")

    click_link(event.name)

    expect(current_path).to eq(vendor_event_path(vendor: vendor.url, id: event.id))
    expect(page).to have_content(event.name)
  end

end
