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

ActiveRecord::Schema.define(version: 20171408001025) do

  create_table "admins", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.date     "birthday"
    t.string   "gender"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "allow_address_ips", force: :cascade do |t|
    t.string   "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         default: 0
    t.string   "comment"
    t.string   "remote_address"
    t.string   "request_uuid"
    t.datetime "created_at"
    t.index ["associated_id", "associated_type"], name: "associated_index"
    t.index ["auditable_id", "auditable_type"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "booking_services", force: :cascade do |t|
    t.integer  "booking_id"
    t.integer  "service_id"
    t.integer  "number"
    t.datetime "time"
    t.integer  "price"
    t.string   "pay"
    t.integer  "user_id"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bookings", force: :cascade do |t|
    t.datetime "check_in"
    t.datetime "check_out"
    t.integer  "childrens"
    t.integer  "adults"
    t.integer  "room_id"
    t.string   "pay"
    t.integer  "price"
    t.integer  "total_payed"
    t.integer  "customer_id"
    t.string   "comments"
    t.integer  "user_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "verification_digest"
    t.boolean  "verified",            default: false
    t.integer  "booking_no"
    t.datetime "verified_at"
    t.string   "status"
  end

  create_table "customers", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "phonenumber"
    t.string   "street"
    t.integer  "number_street"
    t.string   "gender"
    t.string   "city"
    t.string   "postcode"
    t.string   "country"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "employees", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "gender"
    t.date     "bithday"
    t.string   "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "image_room_tops", force: :cascade do |t|
    t.integer  "room_id"
    t.integer  "image_room_top_number"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "room_cannot_chooses", force: :cascade do |t|
    t.integer  "room_id"
    t.date     "from_date"
    t.date     "to_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string   "name"
    t.string   "room_type"
    t.integer  "price"
    t.integer  "adults"
    t.integer  "childrens"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "room_icon"
  end

  create_table "services", force: :cascade do |t|
    t.string   "name"
    t.string   "service_icon"
    t.integer  "price"
    t.string   "status"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "top_images", force: :cascade do |t|
    t.string   "top_icon"
    t.string   "title"
    t.string   "content"
    t.integer  "user_id"
    t.integer  "top_choosed_number", default: 0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password"
    t.string   "confirm_password"
    t.datetime "birthday"
    t.string   "gender"
    t.integer  "phone_number"
    t.string   "address"
    t.string   "user_type"
    t.integer  "type_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

end
