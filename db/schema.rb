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

ActiveRecord::Schema.define(version: 20180330183303) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "orders", force: :cascade do |t|
    t.string "address"
    t.string "latitude"
    t.string "longitude"
    t.string "aasm_state"
    t.float "value"
    t.bigint "store_id"
    t.bigint "courier_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["courier_id"], name: "index_orders_on_courier_id"
    t.index ["store_id"], name: "index_orders_on_store_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "creditor_id"
    t.bigint "debtor_id"
    t.money "amount", scale: 2
    t.bigint "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creditor_id"], name: "index_transactions_on_creditor_id"
    t.index ["debtor_id"], name: "index_transactions_on_debtor_id"
    t.index ["order_id"], name: "index_transactions_on_order_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "user_type"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address"
    t.float "latitude"
    t.float "longitude"
    t.string "business_name"
    t.string "phone"
    t.money "balance", scale: 2
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "orders", "users", column: "courier_id"
  add_foreign_key "orders", "users", column: "store_id"
  add_foreign_key "transactions", "orders"
  add_foreign_key "transactions", "users", column: "creditor_id"
  add_foreign_key "transactions", "users", column: "debtor_id"
end
