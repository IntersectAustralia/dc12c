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

ActiveRecord::Schema.define(:version => 20120320044210) do

  create_table "access_requests", :force => true do |t|
    t.integer "user_id"
    t.integer "papyrus_id"
    t.string  "status"
  end

  create_table "countries", :force => true do |t|
    t.string "name"
  end

  create_table "genres", :force => true do |t|
    t.string "name"
  end

  create_table "languages", :force => true do |t|
    t.string "name"
  end

  create_table "languages_papyri", :force => true do |t|
    t.integer "language_id", :precision => 38, :scale => 0
    t.integer "papyrus_id",  :precision => 38, :scale => 0
  end

  create_table "papyri", :force => true do |t|
    t.string  "inventory_id"
    t.integer "width",                    :precision => 38, :scale => 0
    t.integer "height",                   :precision => 38, :scale => 0
    t.string  "general_note"
    t.string  "note"
    t.string  "paleographic_description"
    t.string  "recto_note"
    t.string  "verso_note"
    t.string  "origin_details"
    t.string  "source_of_acquisition"
    t.string  "preservation_note"
    t.string  "language_note"
    t.string  "summary"
    t.string  "original_text"
    t.string  "translated_text"
    t.integer "date_year",                :precision => 38, :scale => 0
    t.string  "date_era"
    t.integer "country_of_origin_id",     :precision => 38, :scale => 0
    t.integer "genre_id",                 :precision => 38, :scale => 0
    t.string  "visibility",                                              :default => "HIDDEN"
  end

  create_table "permissions", :force => true do |t|
    t.string   "entity"
    t.string   "action"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles_permissions", :id => false, :force => true do |t|
    t.integer "role_id",       :precision => 38, :scale => 0
    t.integer "permission_id", :precision => 38, :scale => 0
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                                 :default => "", :null => false
    t.string   "encrypted_password",                                    :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :precision => 38, :scale => 0, :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        :precision => 38, :scale => 0, :default => 0
    t.datetime "locked_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "status"
    t.integer  "role_id",                :precision => 38, :scale => 0
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "i_users_reset_password_token", :unique => true

end
