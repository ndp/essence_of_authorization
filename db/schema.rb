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

ActiveRecord::Schema.define(:version => 20110326030545) do

  create_table "authorizations", :force => true do |t|
    t.integer "user_id"
    t.string  "verb"
    t.integer "direct_object_id"
    t.string  "direct_object_type"
  end

  add_index "authorizations", ["direct_object_id", "direct_object_type"], :name => "index_authorizations_on_direct_object_id_and_direct_object_type"
  add_index "authorizations", ["user_id", "verb", "direct_object_id", "direct_object_type"], :name => "all_index", :unique => true
  add_index "authorizations", ["user_id"], :name => "index_authorizations_on_user_id"

  create_table "resources", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
