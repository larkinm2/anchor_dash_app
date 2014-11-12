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

ActiveRecord::Schema.define(version: 20141006222637) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pitches", force: true do |t|
    t.string   "body",       limit: 140
    t.integer  "story_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_type"
  end

  add_index "pitches", ["story_id"], name: "index_pitches_on_story_id", using: :btree

  create_table "stories", force: true do |t|
    t.string   "url"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "linked_in"
    t.string   "personal_site"
    t.boolean  "html"
    t.boolean  "css"
    t.boolean  "ruby_on_rails"
    t.boolean  "ruby"
    t.boolean  "python"
    t.boolean  "javascript"
    t.boolean  "product_management"
    t.boolean  "project_management"
    t.boolean  "marketing"
    t.boolean  "ux_design"
    t.boolean  "redis"
    t.boolean  "postgresql"
    t.boolean  "mysql"
    t.string   "personal_location"
    t.string   "personal_description"
    t.string   "image_url"
    t.string   "business_name"
    t.string   "logo_url"
    t.string   "business_location"
    t.string   "business_description"
    t.string   "industry"
    t.string   "founders"
    t.string   "size"
    t.integer  "year_founded"
    t.string   "nickname"
    t.string   "skills"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "password_digest"
    t.string   "user_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",            default: "user"
  end

end
