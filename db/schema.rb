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

ActiveRecord::Schema.define(version: 20160413204354) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string   "external_id"
    t.string   "title"
    t.text     "summary"
    t.string   "url"
    t.string   "image_url"
    t.integer  "feed_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.datetime "published_at"
  end

  add_index "articles", ["feed_id"], name: "index_articles_on_feed_id", using: :btree

  create_table "bookmarked_articles", force: :cascade do |t|
    t.integer  "article_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "bookmarked_articles", ["article_id"], name: "index_bookmarked_articles_on_article_id", using: :btree
  add_index "bookmarked_articles", ["user_id"], name: "index_bookmarked_articles_on_user_id", using: :btree

  create_table "feed_subscriptions", force: :cascade do |t|
    t.integer  "feed_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "feed_subscriptions", ["feed_id"], name: "index_feed_subscriptions_on_feed_id", using: :btree
  add_index "feed_subscriptions", ["user_id"], name: "index_feed_subscriptions_on_user_id", using: :btree

  create_table "feeds", force: :cascade do |t|
    t.string   "cached_title"
    t.string   "url"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.datetime "last_refresh_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "articles", "feeds"
  add_foreign_key "bookmarked_articles", "articles"
  add_foreign_key "bookmarked_articles", "users"
  add_foreign_key "feed_subscriptions", "feeds"
  add_foreign_key "feed_subscriptions", "users"
end
