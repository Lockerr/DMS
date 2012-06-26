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

ActiveRecord::Schema.define(:version => 20120626104324) do

  create_table "1_clients", :force => true do |t|
    t.string   "fio",           :limit => 100, :default => "",  :null => false
    t.text     "comment",                                       :null => false
    t.string   "phone1",        :limit => 50,  :default => "",  :null => false
    t.string   "phone2",        :limit => 50,  :default => "",  :null => false
    t.string   "phone3",        :limit => 50,  :default => "",  :null => false
    t.string   "phone4",        :limit => 50,  :default => "",  :null => false
    t.date     "date",                                          :null => false
    t.string   "adress",        :limit => 200, :default => "",  :null => false
    t.date     "birthday",                                      :null => false
    t.string   "brand",         :limit => 50,  :default => "",  :null => false
    t.string   "manager",       :limit => 100, :default => "",  :null => false
    t.string   "model",         :limit => 160, :default => "0", :null => false
    t.integer  "icon",                                          :null => false
    t.string   "creditmanager", :limit => 100,                  :null => false
    t.datetime "zv",                                            :null => false
    t.datetime "vz",                                            :null => false
    t.datetime "tst",                                           :null => false
    t.datetime "dg",                                            :null => false
    t.datetime "vd",                                            :null => false
    t.datetime "out",                                           :null => false
    t.integer  "icon2",                        :default => 0,   :null => false
    t.string   "vin",           :limit => 50,                   :null => false
    t.integer  "cost",                                          :null => false
    t.string   "status",        :limit => 50,                   :null => false
    t.string   "commercial",    :limit => 50,                   :null => false
    t.string   "tmp",           :limit => 50,                   :null => false
    t.integer  "order"
    t.date     "contract_date"
    t.integer  "id_series"
    t.integer  "id_number"
    t.string   "id_dep"
    t.date     "id_issued"
    t.string   "gifts"
    t.integer  "prepay"
    t.integer  "cause",         :limit => 1
  end

  add_index "1_clients", ["brand"], :name => "brand"
  add_index "1_clients", ["creditmanager"], :name => "creditmanager"
  add_index "1_clients", ["dg"], :name => "dg"
  add_index "1_clients", ["fio", "phone1", "phone2", "phone3", "phone4", "birthday"], :name => "fio"
  add_index "1_clients", ["fio"], :name => "fio_2"
  add_index "1_clients", ["icon"], :name => "icon"
  add_index "1_clients", ["icon2"], :name => "icon2"
  add_index "1_clients", ["id", "dg", "brand"], :name => "dg_index"
  add_index "1_clients", ["id", "out", "brand"], :name => "out_index"
  add_index "1_clients", ["id", "tst", "brand"], :name => "tst_index"
  add_index "1_clients", ["id", "vd", "brand"], :name => "vd_index"
  add_index "1_clients", ["id", "vz", "brand"], :name => "vz_index"
  add_index "1_clients", ["id", "zv", "brand"], :name => "zv_index"
  add_index "1_clients", ["manager"], :name => "manager"
  add_index "1_clients", ["model"], :name => "model"
  add_index "1_clients", ["out"], :name => "out"
  add_index "1_clients", ["phone1"], :name => "phone1"
  add_index "1_clients", ["phone2"], :name => "phone2"
  add_index "1_clients", ["phone3"], :name => "phone3"
  add_index "1_clients", ["phone4"], :name => "phone4"
  add_index "1_clients", ["tmp"], :name => "tmp"
  add_index "1_clients", ["tst"], :name => "tst"
  add_index "1_clients", ["vd"], :name => "vd"
  add_index "1_clients", ["vin", "cost", "status", "commercial"], :name => "vin"
  add_index "1_clients", ["vin"], :name => "vin_2"
  add_index "1_clients", ["vz"], :name => "vz"
  add_index "1_clients", ["zv"], :name => "zv"

  create_table "acts", :force => true do |t|
    t.integer  "car_id"
    t.integer  "person_id"
    t.string   "pts"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "car_pts"
    t.decimal  "price",      :precision => 11, :scale => 2
    t.decimal  "nds",        :precision => 11, :scale => 2
  end

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
    t.integer  "klasse_id"
    t.integer  "model_id"
    t.string   "line_id"
    t.string   "color_id"
    t.string   "interior_id"
    t.integer  "price"
    t.string   "options"
    t.integer  "person_id"
    t.string   "state"
    t.boolean  "published",                  :default => false
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
    t.text     "real_options"
    t.boolean  "restyling",                  :default => false
    t.date     "prod_date"
    t.integer  "engine_number", :limit => 8
    t.boolean  "used",                       :default => false
    t.boolean  "owner",                      :default => true
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

  create_table "clients", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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
    t.integer  "manager_id"
  end

  create_table "communications_orders", :force => true do |t|
    t.integer "communication_id"
    t.integer "order_id"
  end

  create_table "contracts", :force => true do |t|
    t.integer  "person_id"
    t.integer  "car_id"
    t.integer  "manager_id"
    t.decimal  "price",      :precision => 11, :scale => 2
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "prepay"
    t.date     "date"
    t.string   "gifts"
    t.string   "number"
    t.integer  "do_id"
  end

  create_table "dkps", :force => true do |t|
    t.integer  "car_id"
    t.decimal  "price",       :precision => 11, :scale => 2
    t.decimal  "payment",     :precision => 11, :scale => 2
    t.string   "car_pts"
    t.integer  "contract_id"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "person_id"
  end

  create_table "interiors", :force => true do |t|
    t.string  "desc"
    t.string  "code"
    t.integer "klasse_id"
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
    t.string "mobile"
    t.string "email"
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

  create_table "opts", :force => true do |t|
    t.string  "code"
    t.string  "desc"
    t.string  "pseudo_klasse"
    t.integer "klasse_id"
  end

  create_table "orders", :force => true do |t|
    t.string   "source_id"
    t.string   "number"
    t.string   "problem"
    t.string   "solution"
    t.string   "master"
    t.string   "dispatcher"
    t.string   "sum"
    t.datetime "opened"
    t.datetime "closed"
    t.datetime "gone"
    t.integer  "call_result"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "vin"
    t.string   "modelname"
  end

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
    t.decimal  "price",         :precision => 15, :scale => 2
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.decimal  "special_price", :precision => 15, :scale => 2
  end

  create_table "trade_ins", :force => true do |t|
    t.integer  "price"
    t.boolean  "owner"
    t.integer  "person_id"
    t.text     "desc"
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
