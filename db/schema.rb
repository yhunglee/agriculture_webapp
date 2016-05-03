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

ActiveRecord::Schema.define(version: 20160501081930) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "zhparser"

  create_table "flowers", force: :cascade do |t|
    t.string   "name",                         null: false
    t.string   "code",                         null: false
    t.datetime "created_at", default: "now()", null: false
    t.datetime "updated_at", default: "now()", null: false
  end

  add_index "flowers", ["code"], name: "index_flowers_on_code", unique: true, using: :btree

  create_table "fruits", force: :cascade do |t|
    t.string   "name",                         null: false
    t.string   "type"
    t.string   "code",                         null: false
    t.datetime "created_at", default: "now()", null: false
    t.datetime "updated_at", default: "now()", null: false
  end

  add_index "fruits", ["code"], name: "index_fruits_on_code", unique: true, using: :btree

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id",             null: false
    t.integer  "application_id",                null: false
    t.string   "token",             limit: 255, null: false
    t.integer  "expires_in",                    null: false
    t.text     "redirect_uri",                  null: false
    t.datetime "created_at",                    null: false
    t.datetime "revoked_at"
    t.string   "scopes",            limit: 255
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             limit: 255, null: false
    t.string   "refresh_token",     limit: 255
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",                    null: false
    t.string   "scopes",            limit: 255
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",         limit: 255,              null: false
    t.string   "uid",          limit: 255,              null: false
    t.string   "secret",       limit: 255,              null: false
    t.text     "redirect_uri",                          null: false
    t.string   "scopes",       limit: 255, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "owner_type"
  end

  add_index "oauth_applications", ["owner_id", "owner_type"], name: "index_oauth_applications_on_owner_id_and_owner_type", using: :btree
  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "overview_fruit", force: :cascade do |t|
    t.string "name",                       null: false
    t.string "code",                       null: false
    t.date   "date",                       null: false
    t.string "kind"
    t.string "process_type"
    t.float  "total_average_price",        null: false
    t.float  "total_transaction_quantity", null: false
  end

  add_index "overview_fruit", ["name", "code", "date"], name: "index_overview_fruit_on_name_and_code_and_date", unique: true, using: :btree

  create_table "overview_vegetable", force: :cascade do |t|
    t.text  "name"
    t.text  "code"
    t.date  "date",                       null: false
    t.float "total_average_price",        null: false
    t.float "total_transaction_quantity", null: false
  end

  add_index "overview_vegetable", ["name", "code", "date"], name: "index_overview_vegetable_on_name_and_code_and_date", unique: true, using: :btree

  create_table "specified_fruit", force: :cascade do |t|
    t.string "name",             null: false
    t.string "code",             null: false
    t.date   "transaction_date", null: false
    t.string "kind"
    t.string "trade_location"
    t.string "weather",          null: false
    t.float  "upper_price",      null: false
    t.float  "middle_price",     null: false
    t.float  "lower_price",      null: false
    t.float  "average_price",    null: false
    t.float  "trade_quantity",   null: false
  end

  add_index "specified_fruit", ["name", "code", "transaction_date"], name: "index_specified_fruit_on_name_and_code_and_transaction_date", using: :btree
  add_index "specified_fruit", ["trade_location"], name: "index_specified_fruit_on_trade_location", using: :btree
  add_index "specified_fruit", ["weather"], name: "index_specified_fruit_on_weather", using: :btree

  create_table "specified_vegetable", force: :cascade do |t|
    t.text  "name",                   null: false
    t.text  "code",                   null: false
    t.date  "transaction_date",       null: false
    t.text  "trade_location"
    t.text  "kind"
    t.text  "detail_processing_type"
    t.float "upper_price"
    t.float "middle_price"
    t.float "lower_price"
    t.float "average_price"
    t.float "trade_quantity"
  end

  add_index "specified_vegetable", ["detail_processing_type"], name: "index_specified_vegetable_on_detail_processing_type", using: :btree
  add_index "specified_vegetable", ["kind"], name: "index_specified_vegetable_on_kind", using: :btree
  add_index "specified_vegetable", ["name", "code", "transaction_date"], name: "index_specified_vegetable_on_name_and_code_and_transaction_date", using: :btree
  add_index "specified_vegetable", ["trade_location"], name: "index_specified_vegetable_on_trade_location", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "admin",                              default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vegetables", force: :cascade do |t|
    t.string   "name",                         null: false
    t.string   "code",                         null: false
    t.datetime "created_at", default: "now()", null: false
    t.datetime "updated_at", default: "now()", null: false
  end

  add_index "vegetables", ["name", "code"], name: "index_vegetables_on_name_and_code", unique: true, using: :btree

end
