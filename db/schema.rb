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

ActiveRecord::Schema.define(:version => 20120215104919) do

  create_table "assets", :force => true do |t|
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "assets", ["attachable_id", "attachable_type"], :name => "index_assets_on_attachable_id_and_attachable_type"

  create_table "cars", :force => true do |t|
    t.string   "order"
    t.string   "klasse_id"
    t.integer  "model_id"
    t.string   "line_id"
    t.string   "color_id"
    t.string   "interior_id"
    t.integer  "price"
    t.string   "options"
    t.integer  "person_id"
    t.string   "state"
    t.boolean  "published",     :default => false
    t.date     "arrival"
    t.string   "days_at_stock"
    t.string   "comments"
    t.string   "vp"
    t.string   "insurance"
    t.string   "manager_id"
    t.string   "payment_id"
    t.string   "car_type"
    t.string   "run"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "vin"
    t.string   "description"
    t.string   "model_name"
    t.string   "manager_name"
    t.integer  "gpl"
    t.string   "real_options"
    t.boolean  "restyling",     :default => false
    t.date     "prod_date"
  end

  create_table "cars_people", :force => true do |t|
    t.integer "person_id"
    t.integer "car_id"
  end

  create_table "checkins", :force => true do |t|
    t.integer  "car_id"
    t.boolean  "damage"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "comments"
  end

  create_table "communications", :force => true do |t|
    t.integer  "person_id"
    t.string   "subject"
    t.string   "action"
    t.string   "form_action"
    t.datetime "action_date"
    t.string   "next_action"
    t.string   "next_action_form"
    t.datetime "next_action_date"
    t.string   "descriptions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "next_subject"
  end

  create_table "communications_orders", :force => true do |t|
    t.integer "communication_id"
    t.integer "order_id"
  end

  create_table "contracts", :force => true do |t|
    t.integer  "person_id"
    t.integer  "car_id"
    t.integer  "manager_id"
    t.integer  "price"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "prepay"
    t.string   "contact_phone"
    t.date     "date"
  end

  create_table "klasses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lines", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logs", :force => true do |t|
    t.string   "model_name"
    t.integer  "object_id"
    t.integer  "user_id"
    t.text     "parameters"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "managers", :force => true do |t|
    t.string "name"
  end

  create_table "models", :force => true do |t|
    t.string  "name"
    t.string  "klasse"
    t.integer "cars_count"
    t.integer "klasse_id"
  end

  create_table "models_people", :force => true do |t|
    t.integer "model_id"
    t.integer "person_id"
  end

  add_index "models_people", ["model_id"], :name => "index_models_people_on_model_id"
  add_index "models_people", ["person_id", "model_id"], :name => "index_models_people_on_person_id_and_model_id"
  add_index "models_people", ["person_id"], :name => "index_models_people_on_person_id"

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "phones"
    t.string   "email"
    t.string   "descriptions"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "package"
    t.integer  "model_id"
    t.string   "model_name"
    t.integer  "manager_id"
    t.string   "manager_name"
    t.integer  "order_id"
    t.date     "birthday"
    t.string   "address"
    t.integer  "id_series"
    t.integer  "id_number"
    t.string   "id_dep"
  end

  create_table "proposals", :force => true do |t|
    t.integer  "person_id"
    t.integer  "car_id"
    t.integer  "manager_id"
    t.integer  "price"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
