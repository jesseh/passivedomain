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

ActiveRecord::Schema.define(version: 20140101025112) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cash_flows", force: true do |t|
    t.string   "fiat_currency"
    t.decimal  "exchange_rate",               precision: 10, scale: 6
    t.string   "objective"
    t.float    "rig_hash_rate"
    t.float    "watts_to_mine"
    t.float    "watts_to_cool"
    t.decimal  "electricity_rate_fractional", precision: 10, scale: 4
    t.float    "rig_utilization"
    t.decimal  "pool_fee_percent",            precision: 4,  scale: 2
    t.decimal  "facility_cost_fractional",    precision: 10, scale: 4
    t.string   "exchange_provider"
    t.decimal  "exchange_fee_percent",        precision: 4,  scale: 4
    t.decimal  "other_cost_fractional",       precision: 10, scale: 4
    t.float    "mining_difficulty"
    t.decimal  "reward_amount_fractional",    precision: 10, scale: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rigs", force: true do |t|
    t.string  "name"
    t.integer "price_fractional"
    t.string  "price_currency"
    t.integer "power"
    t.float   "hash_rate"
  end

end
