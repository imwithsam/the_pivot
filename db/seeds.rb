platform_role = Role.create(
  name: "platform_admin"
)

store_role = Role.create(
  name: "store_admin"
)

user_role = Role.create(
  name: "registered_user"
)

admin = User.create(
  email: "jorge@turing.io",
  password: "password",
  first_name: "Jorge",
  last_name: "Tellez",
  username: "Jorge's Mierda Choza",
  role: 1
)

vendor = User.create(
  email: "andrew@turing.io",
  password: "password",
  first_name: "Andrew",
  last_name: "Carmer",
  username: "Andrew's Crap Shack",
  role: 1
)

user = User.create(
  email: "josh@turing.io",
  password: "password",
  first_name: "Josh",
  last_name: "Mejia",
  username: "Capn Dick's Shrimp Boat Shack",
  role: 0
)

admin.roles << platform_role
vendor.roles << store_role
user.roles << user_role

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
      100.times do |i|
        user = User.create!(
          username: Faker::Name.name,
          email: Faker::Internet.email,
          first_name: Faker::Name.name,
          last_name: Faker::Name.name,
          password: "password",
        )
        user.roles << Role.find_by(name: "store_admin")
        puts "User #{i}: #{user.username} - #{user.email} created!"
    end
  end

  def generate_events
      500.times do |i|
        vendors  = Role.find_by(name: "store_admin").users
        vendor = vendors.sample
        event = vendor.events.create!(
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
      vendors  = Role.find_by(name: "store_admin").users
      vendor = vendors.sample
      customer = User.find(Random.new.rand(1..100))
      order = vendor.orders.create(customer_id: customer.id)
      add_events(order)
      puts "Order #{i}: Order for #{vendor.username} created!"
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
