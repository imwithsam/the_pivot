def build_products
  @sports = Category.create(
    name: "Sports",
    description: "The largest selection of carnivorous plants in the world!"
  )

  @music = Category.create(
    name: "Music",
    description: "Your carnivorous plants, big or small, are guaranteed" \
    " to love our wide variety of meaty treats."
  )

  @specials = Category.create(
    name: "Special Events",
    description: "From gardening tools to the latest in carnivorous" \
    " botany fashion, we have you covered."
  )

  @sports.products.create(
    name: "Plant 1",
    description: "This is the description for plant 1",
    price: 19.99,
    image_url: "sports/plant-2.jpg")
  @sports.products.create(
    name: "Plant 2",
    description: "This is the description for plant 2",
    price: 29.99,
    image_url: "sports/plant-3.jpg")
  @sports.products.create(
    name: "Plant 3",
    description: "This is the description for plant 3",
    price: 39.99,
    image_url: "sports/venus-fly-traps.jpg")

  @music.products.create(
    name: "Food 1",
    description: "This is the description for music 1",
    price: 19.99,
    image_url: "music/bat.jpg")
  @music.products.create(
    name: "Food 2",
    description: "This is the description for music 2",
    price: 29.99,
    image_url: "music/beetles.jpg")
  @music.products.create(
    name: "Food 3",
    description: "This is the description for food 3",
    price: 39.99,
    image_url: "food/mice.jpg")

  @specials.products.create(
    name: "Accessory 1",
    description: "This is the description for accessory 1",
    price: 19.99,
    image_url: "specials/kit.jpg")
  @specials.products.create(
    name: "Accessory 2",
    description: "This is the description for accessory 2",
    price: 29.99,
    image_url: "specials/rocks.jpg")
  @specials.products.create(
    name: "Accessory 3",
    description: "This is the description for accessory 3",
    price: 49.99,
    image_url: "specials/soil.jpg")
end
