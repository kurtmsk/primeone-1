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

ActiveRecord::Schema.define(version: 20150526060651) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "autos", force: :cascade do |t|
    t.integer  "premium_total",      default: 0
    t.integer  "locations",          default: 0
    t.string   "hired_auto",         default: ""
    t.integer  "hired_auto_premium", default: 0
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "policy_id"
  end

  add_index "autos", ["policy_id"], name: "index_autos_on_policy_id", using: :btree

  create_table "brokers", force: :cascade do |t|
    t.string   "name",        default: ""
    t.string   "agency_name", default: ""
    t.string   "email",       default: ""
    t.string   "phone",       default: ""
    t.text     "notes",       default: ""
    t.string   "street",      default: ""
    t.string   "city",        default: ""
    t.string   "state",       default: ""
    t.string   "zip",         default: ""
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "brokers", ["name"], name: "index_brokers_on_name", unique: true, using: :btree

  create_table "crimes", force: :cascade do |t|
    t.integer  "premium_total",    default: 0
    t.integer  "premium_subtotal", default: 0
    t.integer  "schedule_rating",  default: 0
    t.string   "burglar_alarm",    default: ""
    t.string   "exclude_safe",     default: ""
    t.integer  "ded",              default: 0
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "policy_id"
  end

  add_index "crimes", ["policy_id"], name: "index_crimes_on_policy_id", using: :btree

  create_table "exposure_gls", force: :cascade do |t|
    t.integer  "loc_number",    default: 0
    t.string   "description",   default: ""
    t.string   "cov",           default: ""
    t.string   "code",          default: ""
    t.integer  "premium_basis", default: 0
    t.string   "type",          default: ""
    t.integer  "base_rate",     default: 0
    t.integer  "ilf",           default: 0
    t.integer  "premium",       default: 0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "gl_id"
  end

  add_index "exposure_gls", ["gl_id"], name: "index_exposure_gls_on_gl_id", using: :btree

  create_table "exposures", force: :cascade do |t|
    t.string   "name",          default: ""
    t.string   "valuation",     default: "0"
    t.integer  "limit",         default: 0
    t.integer  "rate",          default: 0
    t.integer  "ded_factor",    default: 0
    t.integer  "co_ins_factor", default: 0
    t.integer  "premium",       default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "location_id"
    t.integer  "crime_id"
  end

  add_index "exposures", ["crime_id"], name: "index_exposures_on_crime_id", using: :btree
  add_index "exposures", ["location_id"], name: "index_exposures_on_location_id", using: :btree

  create_table "gls", force: :cascade do |t|
    t.integer  "premium_total",                 default: 0
    t.integer  "premium_subtotal",              default: 0
    t.integer  "schedule_rating",               default: 0
    t.integer  "multi_loc_factor",              default: 0
    t.integer  "gas_premium",                   default: 0
    t.integer  "rate",                          default: 0
    t.string   "water_gas_tank",                default: ""
    t.integer  "add_ins_number",                default: 0
    t.string   "territory",                     default: ""
    t.string   "comments",                      default: ""
    t.integer  "gen_agg",                       default: 0
    t.integer  "products_completed_operations", default: 0
    t.integer  "personal_advertising_injury",   default: 0
    t.integer  "each_occurence",                default: 0
    t.integer  "fire_damage",                   default: 0
    t.integer  "medical_expense",               default: 0
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "policy_id"
  end

  add_index "gls", ["policy_id"], name: "index_gls_on_policy_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.integer  "number",            default: 0
    t.integer  "premium",           default: 0
    t.integer  "co_ins",            default: 0
    t.integer  "co_ins_factor",     default: 0
    t.integer  "ded",               default: 0
    t.integer  "ded_factor",        default: 0
    t.string   "street",            default: ""
    t.string   "city",              default: ""
    t.string   "state",             default: ""
    t.string   "zip",               default: ""
    t.string   "business_type",     default: ""
    t.string   "coverage_type",     default: ""
    t.string   "construction_type", default: ""
    t.string   "protection_class",  default: ""
    t.string   "updates",           default: ""
    t.string   "year_built",        default: ""
    t.integer  "stories"
    t.integer  "square_feet"
    t.integer  "parking_lot"
    t.integer  "food_limit"
    t.integer  "food_rate"
    t.integer  "food_premium"
    t.integer  "theft_limit"
    t.integer  "theft_rate"
    t.integer  "theft_premium"
    t.integer  "enhc_limit"
    t.integer  "enhc_rate"
    t.integer  "enhc_premium"
    t.integer  "mech_limit"
    t.integer  "mech_rate"
    t.integer  "mech_premium"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "property_id"
  end

  add_index "locations", ["property_id"], name: "index_locations_on_property_id", using: :btree

  create_table "policies", force: :cascade do |t|
    t.string   "policy_number",         default: ""
    t.string   "status",                default: ""
    t.string   "client_code",           default: ""
    t.date     "effective_date"
    t.date     "expiration_date"
    t.string   "forms",                 default: ""
    t.string   "property_forms",        default: ""
    t.string   "gl_forms",              default: ""
    t.string   "crime_forms",           default: ""
    t.string   "auto_forms",            default: ""
    t.integer  "package_premium_total", default: 0
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "broker_id"
    t.string   "name",                  default: ""
    t.string   "quoted_by",             default: ""
    t.string   "business_type",         default: ""
    t.string   "mortgagee",             default: ""
    t.string   "type",                  default: ""
    t.string   "street",                default: ""
    t.string   "city",                  default: ""
    t.string   "state",                 default: ""
    t.string   "zip",                   default: ""
  end

  add_index "policies", ["broker_id"], name: "index_policies_on_broker_id", using: :btree
  add_index "policies", ["policy_number"], name: "index_policies_on_policy_number", unique: true, using: :btree

  create_table "properties", force: :cascade do |t|
    t.integer  "premium_total",       default: 0
    t.integer  "schedule_rating_pct", default: 0
    t.integer  "premium_subtotal",    default: 0
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "policy_id"
  end

  add_index "properties", ["policy_id"], name: "index_properties_on_policy_id", using: :btree

  add_foreign_key "autos", "policies"
  add_foreign_key "crimes", "policies"
  add_foreign_key "exposure_gls", "gls"
  add_foreign_key "exposures", "crimes"
  add_foreign_key "exposures", "locations"
  add_foreign_key "gls", "policies"
  add_foreign_key "locations", "properties"
  add_foreign_key "policies", "brokers"
  add_foreign_key "properties", "policies"
end
