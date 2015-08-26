def build_products

  user_1 = User.create(first_name: "Jane",
  last_name:  "Doe",
  username: "Jane's Shop",
  email:      "jane@doe.com",
  password:   "password")

  user_2 = User.create(first_name: "John",
  last_name:  "Doe",
  username: "John's Shop",
  email:      "john@doe.com",
  password:   "password")

  user_3 = User.create(first_name: "Bob",
  last_name:  "Doe",
  username: "Bob's Shop",
  email:      "bob@doe.com",
  password:   "password")


  @cat_1 = Category.create(
  name: "Sports",
  description: "Stupid Sports"
  )

  @cat_2 = Category.create(
  name: "Music",
  description: "Horrible Music"
  )

  @cat_3 = Category.create(
  name: "Special",
  description: "Crazy Events"
  )

  @event_1 = user_1.events.create(
  name: "event 1" ,
  description: "event 1 description",
  image_url: "http://robohash.org/99.png?set=set2&bgset=bg1&size=200x200",
  price: 25.00,
  status: 0,
  venue: "Denver",
  event_date: DateTime.now,
  category_id: @cat_1.id)

  @event_2 = user_1.events.create(
  name: "event 2" ,
  description: "event 2 description",
  image_url: "http://robohash.org/999.png?set=set2&bgset=bg1&size=200x200",
  price: 50.00,
  status: 0,
  venue: "Denver",
  event_date: DateTime.now,
  category_id: @cat_2.id)

  user_1.events.create(
  name: "event 3" ,
  description: "event 3 description",
  image_url: "http://robohash.org/99.png?set=set2&bgset=bg1&size=200x200",
  price: 75.00,
  status: 0,
  venue: "Denver",
  event_date: DateTime.now,
  category_id: @cat_3.id)

  user_2.events.create(
  name: "event 1 u2" ,
  description: "event 1 description",
  image_url: "http://robohash.org/99.png?set=set2&bgset=bg1&size=200x200",
  price: 25.00,
  status: 0,
  venue: "Denver",
  event_date: DateTime.now,
  category_id: @cat_1.id)

  user_2.events.create(
  name: "event 2 u2" ,
  description: "event 2 description",
  image_url: "http://robohash.org/899.png?set=set2&bgset=bg1&size=200x200",
  price: 50.00,
  status: 0,
  venue: "Denver",
  event_date: DateTime.now,
  category_id: @cat_2.id)

  user_2.events.create(
  name: "event 3 u2" ,
  description: "event 3 description",
  image_url: "http://robohash.org/32499.png?set=set2&bgset=bg1&size=200x200",
  price: 75.00,
  status: 0,
  venue: "Denver",
  event_date: DateTime.now,
  category_id: @cat_3.id)

  user_3.events.create(
  name: "event 1 u3" ,
  description: "event 1 description",
  image_url: "http://robohash.org/32499.png?set=set2&bgset=bg1&size=200x200",
  price: 25.00,
  status: 0,
  venue: "Denver",
  event_date: DateTime.now,
  category_id: @cat_1.id)

  user_3.events.create(
  name: "event 2 u3" ,
  description: "event 2 description",
  image_url: "http://robohash.org/32499.png?set=set2&bgset=bg1&size=200x200",
  price: 50.00,
  status: 0,
  venue: "Denver",
  event_date: DateTime.now,
  category_id: @cat_2.id)

  user_3.events.create(
  name: "event 3 u3" ,
  description: "event 3 description",
  image_url: "http://robohash.org/32499.png?set=set2&bgset=bg1&size=200x200",
  price: 75.00,
  status: 0,
  venue: "Denver",
  event_date: DateTime.now,
  category_id: @cat_3.id)
end
