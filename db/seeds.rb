# Categories
sports = Category.create(
  name:        "Stupid Sports",
  description: "The name says itself"
)

# Event
vendor = User.create(
email: "andrew@turing.io",
password: "password",
first_name: "Andrew",
last_name: "Comber",
username: "Andrew's Crap Shack",
role: 0
)

vendor.events.create(
  name: "Tazer Ball",
  description: "This is real dumb",
  image_url: "sports/ultimate-tazer-ball.jpg",
  price: 12,
  status: 0,
  venue: "Pepsi Centro",
  event_date: DateTime.new(2018, 2,5),
  category_id: sports.id
)
