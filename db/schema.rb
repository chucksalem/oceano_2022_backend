# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_11_28_223419) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "announcements", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "start_at", precision: nil
    t.datetime "ended_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "blogs", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.boolean "admin_only", default: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_blogs_on_user_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "property_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.decimal "amount"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_bookings_on_property_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "deals", force: :cascade do |t|
    t.string "unit_id"
    t.string "text"
  end

  create_table "properties", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.text "amenities"
    t.integer "bathrooms"
    t.integer "bedrooms"
    t.string "code"
    t.text "descriptions"
    t.integer "num_floors"
    t.integer "occupancy"
    t.text "position"
    t.string "type"
    t.text "reviews"
    t.boolean "beachfront"
    t.boolean "pets"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recommendations", force: :cascade do |t|
    t.string "unit_id"
    t.string "text"
  end

  create_table "reviews", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "unit_id"
    t.text "comment"
    t.integer "stars"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "blogs", "users"
  add_foreign_key "bookings", "properties"
  add_foreign_key "bookings", "users"
end
