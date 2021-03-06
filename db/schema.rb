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

ActiveRecord::Schema.define(version: 2016_05_03_141658) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "zhparser"

  create_table "flowers", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.index ["code"], name: "index_flowers_on_code", unique: true
  end

  create_table "fruits", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "kind"
    t.string "code", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.index ["code"], name: "index_fruits_on_code", unique: true
  end

  create_table "oauth_access_grants", id: :serial, force: :cascade do |t|
    t.integer "resource_owner_id", null: false
    t.integer "application_id", null: false
    t.string "token", limit: 255, null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes", limit: 255
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", id: :serial, force: :cascade do |t|
    t.integer "resource_owner_id"
    t.integer "application_id"
    t.string "token", limit: 255, null: false
    t.string "refresh_token", limit: 255
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes", limit: 255
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "uid", limit: 255, null: false
    t.string "secret", limit: 255, null: false
    t.text "redirect_uri", null: false
    t.string "scopes", limit: 255, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "owner_id"
    t.string "owner_type"
    t.index ["owner_id", "owner_type"], name: "index_oauth_applications_on_owner_id_and_owner_type"
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "overview_fruit", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.date "date", null: false
    t.string "kind"
    t.string "process_type"
    t.float "total_average_price", null: false
    t.float "total_transaction_quantity", null: false
    t.index ["name", "code", "date"], name: "index_overview_fruit_on_name_and_code_and_date", unique: true
  end

  create_table "overview_vegetable", id: :serial, force: :cascade do |t|
    t.text "name", collation: "zh_TW.UTF-8"
    t.text "code", collation: "zh_TW.UTF-8"
    t.date "date", null: false
    t.float "total_average_price", null: false
    t.float "total_transaction_quantity", null: false
    t.index ["name", "code", "date"], name: "index_overview_vegetable_on_name_and_code_and_date", unique: true
  end

  create_table "specified_fruit", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.date "transaction_date", null: false
    t.string "kind"
    t.string "trade_location"
    t.string "weather", null: false
    t.float "upper_price", null: false
    t.float "middle_price", null: false
    t.float "lower_price", null: false
    t.float "average_price", null: false
    t.float "trade_quantity", null: false
    t.index ["name", "code", "transaction_date"], name: "index_specified_fruit_on_name_and_code_and_transaction_date"
    t.index ["trade_location"], name: "index_specified_fruit_on_trade_location"
    t.index ["weather"], name: "index_specified_fruit_on_weather"
  end

  create_table "specified_vegetable", id: :serial, force: :cascade do |t|
    t.text "name", null: false, collation: "zh_TW.UTF-8"
    t.text "code", null: false, collation: "zh_TW.UTF-8"
    t.date "transaction_date", null: false
    t.text "trade_location", collation: "zh_TW.UTF-8"
    t.text "kind", collation: "zh_TW.UTF-8"
    t.text "detail_processing_type", collation: "zh_TW.UTF-8"
    t.float "upper_price"
    t.float "middle_price"
    t.float "lower_price"
    t.float "average_price"
    t.float "trade_quantity"
    t.index ["detail_processing_type"], name: "index_specified_vegetable_on_detail_processing_type"
    t.index ["kind"], name: "index_specified_vegetable_on_kind"
    t.index ["name", "code", "transaction_date"], name: "index_specified_vegetable_on_name_and_code_and_transaction_date"
    t.index ["trade_location"], name: "index_specified_vegetable_on_trade_location"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "admin", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vegetables", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.index ["name", "code"], name: "index_vegetables_on_name_and_code", unique: true
  end

end
