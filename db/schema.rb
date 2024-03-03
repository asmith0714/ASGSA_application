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

ActiveRecord::Schema[7.1].define(version: 2024_03_01_113615) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendees", primary_key: "attendee_id", force: :cascade do |t|
    t.boolean "attended"
    t.boolean "rsvp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "event_id"
    t.bigint "member_id"
  end

  create_table "events", primary_key: "event_id", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.time "start_time"
    t.time "end_time"
    t.date "date"
    t.string "description"
    t.integer "capacity"
    t.integer "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "member_notifications", primary_key: "member_notification_id", force: :cascade do |t|
    t.integer "member_id"
    t.integer "notification_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "seen"
  end

  create_table "member_roles", primary_key: "member_role_id", force: :cascade do |t|
    t.integer "member_id"
    t.integer "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "members", primary_key: "member_id", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", default: "", null: false
    t.integer "points"
    t.string "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date_joined"
    t.string "degree"
    t.string "food_allergies"
    t.string "res_topic"
    t.string "res_lab"
    t.string "res_pioneer"
    t.string "res_description"
    t.text "area_of_study"
    t.string "encrypted_password", default: "", null: false
    t.string "uid"
    t.string "avatar_url"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_members_on_email", unique: true
    t.index ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true
  end

  create_table "notifications", primary_key: "notification_id", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_id"
    t.string "title"
    t.date "date"
  end

  create_table "roles", primary_key: "role_id", force: :cascade do |t|
    t.string "name"
    t.string "permissions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "attendees", "events", primary_key: "event_id"
  add_foreign_key "attendees", "members", primary_key: "member_id"
  add_foreign_key "member_notifications", "members", primary_key: "member_id"
  add_foreign_key "member_notifications", "notifications", primary_key: "notification_id"
  add_foreign_key "member_roles", "members", primary_key: "member_id"
  add_foreign_key "member_roles", "roles", primary_key: "role_id"
  add_foreign_key "notifications", "events", primary_key: "event_id"
end
