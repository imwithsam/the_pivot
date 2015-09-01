# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150831234247) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.integer  "type_of"
    t.text     "address_1"
    t.text     "address_2"
    t.text     "city"
    t.text     "state"
    t.text     "zip_code"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "slug"
  end

  add_index "categories", ["slug"], name: "index_categories_on_slug", unique: true, using: :btree

  create_table "event_orders", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "event_id"
    t.integer  "quantity"
    t.decimal  "unit_price", precision: 8, scale: 2
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "event_orders", ["event_id"], name: "index_event_orders_on_event_id", using: :btree
  add_index "event_orders", ["order_id"], name: "index_event_orders_on_order_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.integer  "category_id"
    t.text     "name"
    t.text     "description"
    t.text     "image_url"
    t.decimal  "price",       precision: 8, scale: 2
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "status",                              default: 0
    t.integer  "user_id"
    t.text     "venue"
    t.datetime "event_date"
  end

  add_index "events", ["category_id"], name: "index_events_on_category_id", using: :btree
  add_index "events", ["status"], name: "index_events_on_status", using: :btree
  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "status",      default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "customer_id"
  end

  add_index "orders", ["customer_id"], name: "index_orders_on_customer_id", using: :btree
  add_index "orders", ["status"], name: "index_orders_on_status", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.text     "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_roles", force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "user_roles", ["role_id"], name: "index_user_roles_on_role_id", using: :btree
  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.text     "email"
    t.text     "password_digest"
    t.text     "first_name"
    t.text     "last_name"
    t.integer  "role",            default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.text     "username"
    t.text     "url"
  end

  add_foreign_key "addresses", "users"
  add_foreign_key "event_orders", "events"
  add_foreign_key "event_orders", "orders"
  add_foreign_key "events", "categories"
  add_foreign_key "events", "users"
  add_foreign_key "orders", "users"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
end
