# # Categories
# sports = Category.create(
#   name:        "Stupid Sports",
#   description: "The name says itself"
# )
#
# # Event
vendor = User.create(
email: "andrew@turing.io",
password: "password",
first_name: "Andrew",
last_name: "Comber",
username: "Andrew's Crap Shack",
role: 1
)

Category.create(
name: "Sports",
description: "Stupid Sports"
)

Category.create(
name: "Music",
description: "Horrible Music"
)

Category.create(
name: "Special",
description: "Crazy Events"
)
#
# vendor.events.create(
#   name: "Tazer Ball",
#   description: "This is real dumb",
#   image_url: "sports/ultimate-tazer-ball.jpg",
#   price: 12,
#   status: 0,
#   venue: "Pepsi Centro",
#   event_date: DateTime.new(2018, 2,5),
#   category_id: sports.id
# )

class Seed
  def initialize
    generate_category
    generate_users
    generate_events
    generate_orders
  end

  def generate_category
    25.times do |i|
      cat = Category.create!(name: "#{Faker::Hacker.adjective} #{i}",
      description: Faker::Hacker.say_something_smart)
      puts "Category #{i}: #{cat.name} created!"
    end
  end

  def generate_users
      99.times do |i|
        user = User.create!(
        username: Faker::Name.name,
        email: Faker::Internet.email,
        first_name: Faker::Name.name,
        last_name: Faker::Name.name,
        password: "password",
        role: 0)
        puts "User #{i}: #{user.username} - #{user.email} created!"
    end
  end

  def generate_events
      500.times do |i|
        user = User.find((1..50).to_a.sample)
        event = user.events.create!(
        name: "#{Faker::Commerce.product_name}_#{i}" ,
        description: Faker::Lorem.paragraph,
        image_url: "http://loremflickr.com/320/240/sports?random=#{i}",
        price: Faker::Commerce.price,
        status: 0,
        venue: Faker::Address.city,
        event_date: Faker::Date.forward((1..300).to_a.sample),
        category_id: Random.new.rand(1..28)

        )
        puts "Event #{i}: #{event.name} created!"
    end
  end

  def generate_orders
    100.times do |i|
      user  = User.find(Random.new.rand(1..100))
      order = user.orders.create!
      add_events(order)
      puts "Order #{i}: Order for #{user.username} created!"
    end
  end

  private

  def add_events(order)
    10.times do |i|
      event = Event.find(Random.new.rand(1..500))
      order.event_orders.create(event_id: event.id, quantity: 1, unit_price: event.price)
      puts "#{i}: Added event #{event.name} to order #{order.id}."
    end
  end
end

Seed.new
