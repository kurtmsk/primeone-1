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

ActiveRecord::Schema.define(version: 20150530171716) do

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
    t.string   "name",                  default: ""
    t.string   "dba",                   default: ""
    t.string   "contact_name",          default: ""
    t.string   "email",                 default: ""
    t.string   "phone",                 default: ""
    t.text     "notes",                 default: ""
    t.integer  "commission",            default: 0
    t.string   "agreement_sent",        default: ""
    t.string   "agreement_completed",   default: ""
    t.string   "pac_risk_fee_schedule", default: ""
    t.string   "target_premium",        default: ""
    t.string   "street",                default: ""
    t.string   "city",                  default: ""
    t.string   "state",                 default: ""
    t.string   "zip",                   default: ""
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
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

  create_table "docs", force: :cascade do |t|
    t.string   "file",        default: ""
    t.string   "form_code",   default: ""
    t.string   "description", default: ""
    t.string   "var_1",       default: ""
    t.string   "var_2",       default: ""
    t.string   "var_3",       default: ""
    t.string   "var_4",       default: ""
    t.string   "var_5",       default: ""
    t.string   "var_6",       default: ""
    t.boolean  "active",      default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "policy_id"
  end

  add_index "docs", ["policy_id"], name: "index_docs_on_policy_id", using: :btree

  create_table "exposure_gls", force: :cascade do |t|
    t.string   "name",          default: ""
    t.integer  "loc_number",    default: 0
    t.string   "description",   default: ""
    t.string   "cov",           default: ""
    t.string   "code",          default: ""
    t.integer  "premium_basis", default: 0
    t.string   "sales_type",    default: ""
    t.decimal  "base_rate",     default: 0.0
    t.decimal  "ilf",           default: 0.0
    t.integer  "premium",       default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
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
    t.decimal  "rate",                          default: 0.0
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
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
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
    t.integer  "stories",           default: 0
    t.integer  "square_feet",       default: 0
    t.integer  "parking_lot",       default: 0
    t.integer  "food_rate",         default: 0
    t.integer  "food_premium",      default: 0
    t.integer  "theft_limit",       default: 0
    t.integer  "theft_premium",     default: 0
    t.integer  "enhc_rate",         default: 0
    t.integer  "enhc_premium",      default: 0
    t.integer  "mech_premium",      default: 0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "property_id"
  end

  add_index "locations", ["property_id"], name: "index_locations_on_property_id", using: :btree

  create_table "policies", force: :cascade do |t|
    t.string   "policy_number",  default: ""
    t.string   "status",         default: ""
    t.string   "client_code",    default: ""
    t.string   "name",           default: ""
    t.date     "effective_date", default: '1995-11-08'
    t.string   "forms",          default: ""
    t.string   "property_forms", default: ""
    t.string   "gl_forms",       default: ""
    t.string   "crime_forms",    default: ""
    t.string   "auto_forms",     default: ""
    t.string   "A",              default: ""
    t.date     "B",              default: '1995-11-08'
    t.date     "C",              default: '1995-11-08'
    t.string   "D",              default: ""
    t.string   "E",              default: ""
    t.string   "F",              default: ""
    t.string   "G",              default: ""
    t.string   "H",              default: ""
    t.string   "I",              default: ""
    t.string   "J",              default: ""
    t.string   "K",              default: "0"
    t.string   "L",              default: ""
    t.string   "M",              default: ""
    t.string   "N",              default: ""
    t.string   "O",              default: ""
    t.string   "P",              default: ""
    t.string   "Q",              default: ""
    t.string   "R",              default: ""
    t.string   "S",              default: "0"
    t.string   "T",              default: "0"
    t.string   "U",              default: "0"
    t.string   "V",              default: ""
    t.string   "W",              default: ""
    t.string   "X",              default: "0"
    t.string   "Y",              default: "0"
    t.string   "Z",              default: "0"
    t.string   "AA",             default: "0"
    t.string   "AB",             default: "0"
    t.string   "AC",             default: "0"
    t.string   "AD",             default: "0"
    t.string   "AE",             default: ""
    t.string   "AF",             default: ""
    t.string   "AG",             default: ""
    t.string   "AH",             default: ""
    t.string   "AI",             default: ""
    t.string   "AJ",             default: "0"
    t.string   "AK",             default: ""
    t.string   "AL",             default: ""
    t.string   "AM",             default: "0"
    t.string   "AN",             default: ""
    t.string   "AO",             default: "0"
    t.string   "AP",             default: ""
    t.string   "AQ",             default: "0"
    t.string   "AR",             default: "0"
    t.string   "AS",             default: "0"
    t.string   "AT",             default: ""
    t.string   "AU",             default: "0"
    t.string   "AV",             default: "0"
    t.string   "AW",             default: "0"
    t.string   "AX",             default: "0"
    t.string   "AY",             default: "0"
    t.string   "AZ",             default: ""
    t.string   "BA",             default: "0"
    t.string   "BB",             default: "0"
    t.string   "BC",             default: "0"
    t.string   "BD",             default: "0"
    t.string   "BE",             default: "0"
    t.string   "BF",             default: "0"
    t.string   "BG",             default: "0"
    t.string   "BH",             default: "0"
    t.string   "BI",             default: "0"
    t.string   "BJ",             default: "0"
    t.string   "BK",             default: "0"
    t.string   "BL",             default: ""
    t.string   "BM",             default: ""
    t.string   "BN",             default: "0"
    t.string   "BO",             default: "0"
    t.string   "BP",             default: "0"
    t.string   "BQ",             default: ""
    t.string   "BR",             default: "0"
    t.string   "BS",             default: ""
    t.string   "BT",             default: "0"
    t.string   "BU",             default: "0"
    t.string   "BV",             default: "0"
    t.string   "BW",             default: ""
    t.string   "BX",             default: "0"
    t.string   "BY",             default: ""
    t.string   "BZ",             default: "0"
    t.string   "CA",             default: "0"
    t.string   "CB",             default: "0"
    t.string   "CC",             default: ""
    t.string   "CD",             default: ""
    t.string   "CE",             default: "0"
    t.string   "CF",             default: "0"
    t.string   "CG",             default: "0"
    t.string   "CH",             default: "0"
    t.string   "CI",             default: "0"
    t.string   "CJ",             default: "0"
    t.string   "CK",             default: "0"
    t.string   "CL",             default: ""
    t.string   "CM",             default: "0"
    t.string   "CN",             default: ""
    t.string   "CO",             default: "0"
    t.string   "CP",             default: ""
    t.string   "CQ",             default: ""
    t.string   "CR",             default: "0"
    t.string   "CS",             default: "0"
    t.string   "CT",             default: ""
    t.string   "CU",             default: "0"
    t.string   "CV",             default: "0"
    t.string   "CW",             default: "0"
    t.string   "CX",             default: "0"
    t.string   "CY",             default: ""
    t.string   "CZ",             default: ""
    t.string   "DA",             default: "0"
    t.string   "DB",             default: "0"
    t.string   "DC",             default: ""
    t.string   "DD",             default: "0"
    t.string   "DE",             default: "0"
    t.string   "DF",             default: "0"
    t.string   "DG",             default: "0"
    t.string   "DH",             default: "0"
    t.string   "DI",             default: "0"
    t.string   "DJ",             default: "0"
    t.string   "DK",             default: "0"
    t.string   "DL",             default: "0"
    t.string   "DM",             default: "0"
    t.string   "DN",             default: "0"
    t.string   "DO",             default: ""
    t.string   "DP",             default: "0"
    t.string   "DQ",             default: "0"
    t.string   "DR",             default: "0"
    t.string   "DS",             default: "0"
    t.string   "DT",             default: "0"
    t.string   "DU",             default: "0"
    t.string   "DV",             default: "0"
    t.string   "DW",             default: "0"
    t.string   "DX",             default: ""
    t.string   "DY",             default: "0"
    t.string   "DZ",             default: "0"
    t.string   "EA",             default: ""
    t.string   "EB",             default: "0"
    t.string   "EC",             default: "0"
    t.string   "ED",             default: ""
    t.string   "EE",             default: "0"
    t.string   "EF",             default: "0"
    t.string   "EG",             default: "0"
    t.string   "EH",             default: "0"
    t.string   "EI",             default: "0"
    t.string   "EJ",             default: ""
    t.string   "EK",             default: "0"
    t.string   "EL",             default: ""
    t.string   "EM",             default: ""
    t.string   "EN",             default: ""
    t.string   "EO",             default: "0"
    t.string   "EP",             default: ""
    t.string   "EQ",             default: ""
    t.string   "ER",             default: ""
    t.string   "ES",             default: ""
    t.string   "ET",             default: ""
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "broker_id"
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
  add_foreign_key "docs", "policies"
  add_foreign_key "exposure_gls", "gls"
  add_foreign_key "exposures", "crimes"
  add_foreign_key "exposures", "locations"
  add_foreign_key "gls", "policies"
  add_foreign_key "locations", "properties"
  add_foreign_key "policies", "brokers"
  add_foreign_key "properties", "policies"
end
