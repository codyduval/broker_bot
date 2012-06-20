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

ActiveRecord::Schema.define(:version => 20120523151437) do

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"

  create_table "listings", :force => true do |t|
    t.string   "address"
    t.string   "url"
    t.integer  "listed_price"
    t.string   "open_house_date"
    t.string   "map_url"
    t.text     "listed_description"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.date     "date_listed"
    t.date     "date_entered"
    t.integer  "days_on_market"
    t.integer  "property_rating"
    t.boolean  "active_flag"
  end

  create_table "notes", :force => true do |t|
    t.text     "note_text"
    t.string   "note_author"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "listing_id"
  end

  create_table "photos", :force => true do |t|
    t.string   "photo_url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
