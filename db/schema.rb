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

ActiveRecord::Schema.define(version: 20180407183714) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "academic_educations", force: :cascade do |t|
    t.string "course", null: false
    t.string "institution", null: false
    t.date "finished_in"
    t.integer "level", default: 0, null: false
    t.bigint "guide_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guide_id"], name: "index_academic_educations_on_guide_id"
  end

  create_table "contracts", force: :cascade do |t|
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.float "price"
    t.text "goals", null: false
    t.bigint "guide_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.index ["guide_id"], name: "index_contracts_on_guide_id"
    t.index ["user_id"], name: "index_contracts_on_user_id"
  end

  create_table "guides", force: :cascade do |t|
    t.datetime "birthdate", null: false
    t.string "main_phone", null: false
    t.string "secondary_phone"
    t.text "bio", null: false
    t.integer "status", default: 0
    t.bigint "user_id"
    t.index ["user_id"], name: "index_guides_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.bigint "guide_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "street", default: "", null: false
    t.string "district", default: "", null: false
    t.string "city", default: "", null: false
    t.string "state", default: "", null: false
    t.index ["guide_id"], name: "index_locations_on_guide_id"
  end

  create_table "payments", force: :cascade do |t|
    t.float "comission", default: 0.0, null: false
    t.integer "payment_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "contract_id"
    t.index ["contract_id"], name: "index_payments_on_contract_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "type"
    t.datetime "birthdate"
    t.string "main_phone"
    t.string "secondary_phone"
    t.text "bio"
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "contracts", "guides"
  add_foreign_key "contracts", "users"
  add_foreign_key "guides", "users"
end
