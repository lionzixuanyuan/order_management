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

ActiveRecord::Schema.define(version: 20150416064023) do

  create_table "customers", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_details", force: true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "amount",     default: 1
    t.decimal  "discount",   default: 100.0
    t.decimal  "sum"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.string   "code"
    t.integer  "customer_id"
    t.integer  "totle_amount"
    t.decimal  "totle_sum"
    t.string   "inceptor"
    t.string   "saleman"
    t.integer  "creator_id"
    t.string   "aasm_state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shipment_code"
  end

  create_table "products", force: true do |t|
    t.string   "name"
    t.string   "unit"
    t.decimal  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "roles_mask"
  end

end
