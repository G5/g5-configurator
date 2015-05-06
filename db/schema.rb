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

ActiveRecord::Schema.define(version: 20150427201404) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "entries", force: true do |t|
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "g5_authenticatable_users", force: true do |t|
    t.string   "email",              default: "",   null: false
    t.string   "provider",           default: "g5", null: false
    t.string   "uid",                               null: false
    t.string   "g5_access_token"
    t.integer  "sign_in_count",      default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "g5_authenticatable_users", ["email"], name: "index_g5_authenticatable_users_on_email", unique: true, using: :btree
  add_index "g5_authenticatable_users", ["provider", "uid"], name: "index_g5_authenticatable_users_on_provider_and_uid", unique: true, using: :btree

  create_table "instructions", force: true do |t|
    t.integer  "remote_app_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "target_app_kind"
    t.string   "updated_app_kinds", default: [], array: true
  end

  create_table "instructions_target_apps", force: true do |t|
    t.integer  "instruction_id"
    t.integer  "target_app_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "remote_apps", force: true do |t|
    t.integer  "entry_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "kind"
    t.string   "git_repo"
    t.string   "client_uid"
    t.string   "client_name"
    t.string   "heroku_app_name"
    t.string   "organization"
  end

end
