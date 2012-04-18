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

ActiveRecord::Schema.define(:version => 20120417035256) do

  create_table "access_requests", :force => true do |t|
    t.integer  "user_id",        :precision => 38, :scale => 0
    t.integer  "papyrus_id",     :precision => 38, :scale => 0
    t.string   "status"
    t.datetime "date_requested"
    t.datetime "date_approved"
  end

  create_table "genres", :force => true do |t|
    t.string "name"
  end

  create_table "images", :force => true do |t|
    t.string   "caption"
    t.integer  "papyrus_id",                      :precision => 38, :scale => 0
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size",                 :precision => 38, :scale => 0
    t.datetime "image_updated_at"
    t.string   "ordering",           :limit => 1
  end

  create_table "languages", :force => true do |t|
    t.string "name"
  end

  create_table "languages_papyri", :id => false, :force => true do |t|
    t.integer "language_id", :precision => 38, :scale => 0
    t.integer "papyrus_id",  :precision => 38, :scale => 0
  end

  create_table "papyri", :force => true do |t|
    t.string  "inventory_id"
    t.string  "general_note"
    t.string  "lines_of_text",            :limit => 1023
    t.string  "paleographic_description", :limit => 1023
    t.string  "origin_details"
    t.string  "source_of_acquisition"
    t.string  "preservation_note",        :limit => 1023
    t.string  "language_note"
    t.string  "summary"
    t.string  "original_text"
    t.string  "translated_text"
    t.integer "country_of_origin_id",                     :precision => 38, :scale => 0
    t.integer "genre_id",                                 :precision => 38, :scale => 0
    t.string  "visibility",                                                              :default => "HIDDEN"
    t.string  "dimensions",               :limit => 511
    t.integer "mqt_number",                               :precision => 38, :scale => 0,                       :null => false
    t.integer "date_from",                                :precision => 38, :scale => 0
    t.integer "date_to",                                  :precision => 38, :scale => 0
    t.string  "mqt_note"
    t.string  "apis_id",                  :limit => 32
    t.integer "trismegistos_id",                          :precision => 38, :scale => 0
    t.string  "physical_location"
    t.string  "date_note"
    t.string  "material"
    t.string  "conservation_note",        :limit => 1023
    t.string  "other_characteristics",    :limit => 1023
    t.string  "recto_verso_note",         :limit => 511
    t.string  "type_of_text"
    t.string  "modern_textual_dates",     :limit => 511
    t.string  "publications",             :limit => 127
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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
