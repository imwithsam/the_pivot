def build_test_data
  @user_1 = User.create(
  first_name: "Jane",
  last_name: "Doe",
  username: "Jane's Shop",
  email: "jane@doe.com",
  password: "password")

  @user_2 = User.create(
  first_name: "John",
  last_name: "Doe",
  username: "John's Shop",
  email: "john@doe.com",
  password: "password")

  @user_3 = User.create(
  first_name: "Bob",
  last_name: "Doe",
  username: "Bob's Shop",
  email: "bob@doe.com",
  password: "password")

  @store_admin_1 = User.create(
  first_name: "James",
  last_name: "Golick",
  username: "Golick's Tickets",
  email: "golick@example.com",
  password: "password")

  @store_admin_2 = User.create(
  first_name: "Jose",
  last_name: "Valim",
  username: "Jose's Tickets",
  email: "jose@example.com",
  password: "password")

  @platform_admin_1 = User.create(
  first_name: "Samson",
  last_name: "Brock",
  username: "Sam's Curios and Beyond",
  email: "sam@example.com",
  password: "password")

  @platform_admin_2 = User.create(
  first_name: "Tyler",
  last_name: "Durden",
  username: "Tyler's Clubs",
  email: "tyler@example.com",
  password: "password")

  @reg_user_role = Role.create(name: "registered_user")
  @store_admin_role = Role.create(name: "store_admin")
  @platform_admin_role = Role.create(name: "platform_admin")

  @user_1.roles << @reg_user_role
  @user_2.roles << @reg_user_role
  @user_3.roles << @reg_user_role
  @store_admin_1.roles << @store_admin_role
  @store_admin_2.roles << @store_admin_role
  @platform_admin_1.roles << @platform_admin_role
  @platform_admin_2.roles << @platform_admin_role

  @cat_1 = Category.create(
  name: "Not Quite Sports",
  description: "Stupid Sports")

  @cat_2 = Category.create(
  name: "80's German SynthPop",
  description: "Horrible Music")

  @cat_3 = Category.create(
  name: "Competitive Eating",
  description: "Crazy Events")

  @event_1 = Event.create(
  name: "event 1" ,
  description: "event 1 description",
  image_url: "http://robohash.org/99.png?set=set2&bgset=bg1&size=200x200",
  price: 25.00,
  status: 0,
  venue: "Denver",
  event_date: DateTime.now,
  category_id: @cat_1.id)

  @event_2 = Event.create(
  name: "event 2" ,
  description: "event 2 description",
  image_url: "http://robohash.org/999.png?set=set2&bgset=bg1&size=200x200",
  price: 50.00,
  status: 0,
  venue: "Denver",
  event_date: DateTime.now,
  category_id: @cat_2.id)

  @event_3 = Event.create(
  name: "event 3" ,
  description: "event 3 description",
  image_url: "http://robohash.org/99.png?set=set2&bgset=bg1&size=200x200",
  price: 75.00,
  status: 0,
  venue: "Denver",
  event_date: DateTime.now,
  category_id: @cat_3.id)

  @event_4 = Event.create(
  name: "event 1 u2" ,
  description: "event 1 u2 description",
  image_url: "http://robohash.org/99.png?set=set2&bgset=bg1&size=200x200",
  price: 25.00,
  status: 0,
  venue: "Denver",
  event_date: DateTime.now,
  category_id: @cat_1.id)

  @event_5 = Event.create(
  name: "event 2 u2" ,
  description: "event 2 u2 description",
  image_url: "http://robohash.org/899.png?set=set2&bgset=bg1&size=200x200",
  price: 50.00,
  status: 0,
  venue: "Denver",
  event_date: DateTime.now,
  category_id: @cat_2.id)

  @event_6 = Event.create(
  name: "event 3 u2" ,
  description: "event 3 u2 description",
  image_url: "http://robohash.org/32499.png?set=set2&bgset=bg1&size=200x200",
  price: 75.00,
  status: 0,
  venue: "Denver",
  event_date: DateTime.now,
  category_id: @cat_3.id)

  @event_7 = Event.create(
  name: "event 1 u3" ,
  description: "event 1 u3 description",
  image_url: "http://robohash.org/32499.png?set=set2&bgset=bg1&size=200x200",
  price: 25.00,
  status: 0,
  venue: "Denver",
  event_date: DateTime.now,
  category_id: @cat_1.id)

  @event_8 = Event.create(
  name: "event 2 u3" ,
  description: "event 2 u3 description",
  image_url: "http://robohash.org/32499.png?set=set2&bgset=bg1&size=200x200",
  price: 50.00,
  status: 0,
  venue: "Denver",
  event_date: DateTime.now,
  category_id: @cat_2.id)

  @event_9 = Event.create(
  name: "event 3 u3" ,
  description: "event 3 u3 description",
  image_url: "http://robohash.org/32499.png?set=set2&bgset=bg1&size=200x200",
  price: 75.00,
  status: 0,
  venue: "Denver",
  event_date: DateTime.now,
  category_id: @cat_3.id)

  @user_1.events << @event_1
  @user_1.events << @event_2
  @user_1.events << @event_3
  @user_2.events << @event_4
  @user_2.events << @event_5
  @user_2.events << @event_6
  @user_3.events << @event_7
  @user_3.events << @event_8
  @user_3.events << @event_9
  @store_admin_1.events << @event_1
  @store_admin_1.events << @event_2
  @store_admin_1.events << @event_3
  @store_admin_2.events << @event_4
  @store_admin_2.events << @event_5
  @store_admin_2.events << @event_6
end
