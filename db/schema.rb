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

ActiveRecord::Schema.define(version: 20170825234155) do

  create_table "classrooms", force: :cascade do |t|
    t.string   "name"
    t.string   "password_digest"
    t.boolean  "has_grades"
    t.boolean  "has_attendance"
    t.float    "minimum_grade"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "logs", force: :cascade do |t|
    t.string   "action"
    t.string   "subject"
    t.integer  "subject_id"
    t.integer  "user_id"
    t.integer  "classroom_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["classroom_id"], name: "index_logs_on_classroom_id"
    t.index ["user_id"], name: "index_logs_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "classroom_id"
    t.string   "role"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["classroom_id"], name: "index_subscriptions_on_classroom_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.string   "cep"
    t.string   "address"
    t.integer  "number"
    t.string   "complement"
    t.string   "neighborhood"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "photo_name"
    t.string   "language"
    t.string   "timezone"
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "activation_digest"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.boolean  "admin"
    t.boolean  "confirmed"
    t.datetime "confirmed_at"
    t.datetime "last_access"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

end
