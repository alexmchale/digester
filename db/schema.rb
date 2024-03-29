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

ActiveRecord::Schema.define(version: 20140907180605) do

  create_table "articles", force: true do |t|
    t.text     "url"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "title"
    t.text     "author"
    t.datetime "published_at"
    t.text     "transcript"
    t.string   "sha256"
    t.integer  "user_id"
    t.integer  "mp3_duration"
    t.string   "mp3_mime_type"
    t.integer  "mp3_file_size"
    t.text     "mp3_url"
    t.integer  "instapaper_bookmark_id"
    t.string   "instapaper_hash"
    t.boolean  "body_provided"
    t.datetime "deleted_at"
    t.text     "raw_html"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "users", force: true do |t|
    t.text     "email"
    t.string   "password_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "secret_key"
    t.string   "feed_title"
    t.text     "feed_description"
    t.text     "feed_image_url"
    t.string   "instapaper_token"
    t.string   "instapaper_token_secret"
    t.string   "bookmark_key"
  end

end
