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

ActiveRecord::Schema.define(version: 20140529181956) do

  create_table "twilio_credentials", force: true do |t|
    t.string   "sid"
    t.string   "auth_token"
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "twilio_credentials", ["phone_number"], name: "index_twilio_credentials_on_phone_number", unique: true

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "phone_number"
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "confirmation_code"
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["phone_number"], name: "index_users_on_phone_number", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
