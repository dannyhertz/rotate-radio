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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120818000310) do

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.string   "rdio_id"
    t.string   "rdio_url"
    t.string   "rdio_avatar"
    t.string   "twitter_id"
    t.string   "twitter_username"
    t.string   "twitter_avatar"
    t.boolean  "verified",         :default => false
    t.boolean  "flagged",          :default => false
    t.date     "last_checked"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "artists_rotations", :id => false, :force => true do |t|
    t.integer "artist_id"
    t.integer "rotation_id"
  end

  create_table "follow_exceptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "artist_id"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "providers", :force => true do |t|
    t.integer  "user_id"
    t.string   "uid"
    t.string   "service"
    t.string   "url"
    t.string   "username"
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "rotations", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "avatar"
    t.integer  "rotation_size"
    t.integer  "rotation_frequency"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "rotation_status",    :default => 1
  end

end
