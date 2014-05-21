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

ActiveRecord::Schema.define(version: 20140521234223) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "interests", force: true do |t|
    t.text     "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interests", ["name"], name: "index_interests_on_name", unique: true, using: :btree

  create_table "lunch_dates", force: true do |t|
    t.integer  "creator_id"
    t.text     "location_name"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "date_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comment"
    t.boolean  "dutch"
    t.text     "time_limit"
  end

  create_table "matches", force: true do |t|
    t.integer  "user_id"
    t.integer  "lunch_date_id"
    t.text     "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "username",                            null: false
    t.datetime "dob",                                 null: false
    t.string   "gender",                              null: false
    t.string   "sexual_orientation",                  null: false
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "image_url"
    t.string   "quote"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
