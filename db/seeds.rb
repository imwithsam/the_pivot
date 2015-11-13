class Seed
  def initialize
    generate_roles
    generate_category
    generate_users
    generate_events

    15.times do
      generate_orders
    end
  end

  def generate_roles
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
      username: "Jorge's Event Emporium",
      role: 1
      )

    vendor = User.create(
      email: "andrew@turing.io",
      password: "password",
      first_name: "Andrew",
      last_name: "Carmer",
      username: "Andrew's Amazing Activities",
      role: 1
      )

    user = User.create(
      email: "josh@turing.io",
      password: "password",
      first_name: "Josh",
      last_name: "Mejia",
      username: "Josh's Wild and Crazy Adventures",
      role: 0
      )

    admin.addresses.create(
      type_of: 0,
      address_1: Faker::Address.street_address,
      address_2: Faker::Address.secondary_address,
      city:      Faker::Address.city,
      state:     Faker::Address.state_abbr,
      zip_code:  Faker::Address.zip_code.to_i
      )

    admin.addresses.create(
      type_of: 1,
      address_1: Faker::Address.street_address,
      address_2: Faker::Address.secondary_address,
      city:      Faker::Address.city,
      state:     Faker::Address.state_abbr,
      zip_code:  Faker::Address.zip_code.to_i
      )

    vendor.addresses.create(
      type_of: 0,
      address_1: Faker::Address.street_address,
      address_2: Faker::Address.secondary_address,
      city:      Faker::Address.city,
      state:     Faker::Address.state_abbr,
      zip_code:  Faker::Address.zip_code.to_i
      )

    vendor.addresses.create(
      type_of: 1,
      address_1: Faker::Address.street_address,
      address_2: Faker::Address.secondary_address,
      city:      Faker::Address.city,
      state:     Faker::Address.state_abbr,
      zip_code:  Faker::Address.zip_code.to_i
      )

    user.addresses.create(
      type_of: 0,
      address_1: Faker::Address.street_address,
      address_2: Faker::Address.secondary_address,
      city:      Faker::Address.city,
      state:     Faker::Address.state_abbr,
      zip_code:  Faker::Address.zip_code.to_i
      )

    user.addresses.create(
      type_of: 1,
      address_1: Faker::Address.street_address,
      address_2: Faker::Address.secondary_address,
      city:      Faker::Address.city,
      state:     Faker::Address.state_abbr,
      zip_code:  Faker::Address.zip_code.to_i
      )

    admin.roles << platform_role
    vendor.roles << store_role
    user.roles << user_role
  end

  def generate_category
    Category.create(
      name: "Competitive Eating",
      description: "The pinnacle of competition"
      )

    Category.create(
      name: "Tazerball",
      description: "Forget all other sports"
      )

    Category.create(
      name: "80's German SynthPop",
      description: "Music to your ears"
      )

    Category.create(
      name: "Not Quite Sports",
      description: "But almost..."
      )

    Category.create(
      name: "3rd Person Skiing",
      description: "Extreme sports"
      )

    Category.create(
      name: "Chess Boxing",
      description: "Hybrid sports"
      )

    Category.create(
      name: "Freestyle Canoeing",
      description: "For the adventurous..."
      )

    Category.create(
      name: "Combat Juggling",
      description: "Taking it to the next level"
      )

    Category.create(
      name: "Lawnmower Ice Racing",
      description: "Not just for lawns"
      )

    Category.create(
      name: "Head Pong",
      description: "Pong for the win"
      )
  end

  def generate_users
    100.times do |i|
      user = User.create!(
        username: Faker::Internet.user_name,
        email: Faker::Internet.email,
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        password: "password",
        )
      if i < 19
        user.roles << Role.find_by(name: "store_admin")
      else
        user.roles << Role.find_by(name: "registered_user")
      end

      user.addresses.create!(
        type_of: 0,
        address_1: Faker::Address.street_address,
        address_2: Faker::Address.secondary_address,
        city:      Faker::Address.city,
        state:     Faker::Address.state_abbr,
        zip_code:  Faker::Address.zip_code.to_i
        )

      user.addresses.create!(
        type_of: 1,
        address_1: Faker::Address.street_address,
        address_2: Faker::Address.secondary_address,
        city:      Faker::Address.city,
        state:     Faker::Address.state_abbr,
        zip_code:  Faker::Address.zip_code.to_i
        )
      puts "User #{i}: #{user.username} - #{user.email} created!"
    end
  end

  def generate_events
    500.times do |i|
      vendors  = Role.find_by(name: "store_admin").users
      vendor = vendors.sample
      event = vendor.events.create!(
        name: "#{Faker::Commerce.product_name}_#{i}",
        description: Faker::Hacker.say_something_smart,
        image_url: "http://loremflickr.com/320/240/sports?random=#{i}",
        price: Faker::Commerce.price,
        status: 0,
        venue: Faker::Address.city,
        event_date: Faker::Date.forward((1..300).to_a.sample),
        category_id: 1
        )
      if event.id.to_s.chars.last.to_i == 0
        event.update_attributes(category_id: 10)
      else
        event.update_attributes(category_id: event.id.to_s.chars.last.to_i)
      end
      puts "Event #{i}: #{event.name} created!"
    end
  end

  def generate_orders
    cart = []
    10.times do |i|
      event = Event.find(Random.new.rand(1..500))
      cart << event
    end
    unique_vendor_ids = {}

    cart.each do |cart_item|
      unique_vendor_ids[cart_item.user.id] = 0
    end

    unique_vendor_ids.each_key do |vendor_id|
      order = Order.create(
        user_id: vendor_id,
        status:  "ordered",
        customer_id: Random.new.rand(1..100)
        )

      vendors_cart = []

      cart.each do |item|
        if item.user_id.eql?(vendor_id)
          vendors_cart << item
        end
      end

      vendors_cart.each do |vendor_event|
        EventOrder.create(
          order_id:   order.id,
          event_id:   vendor_event.id,
          quantity:   Random.new.rand(1..5),
          unit_price: vendor_event.price
          )
      end
    end
  end
end

Seed.new
