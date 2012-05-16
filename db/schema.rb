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

ActiveRecord::Schema.define(:version => 20120516111655) do

  create_table "dyna_models", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "definition"
    t.string   "solver"
    t.string   "estimation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "experiments", :force => true do |t|
    t.text     "description"
    t.integer  "model_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  add_index "experiments", ["model_id"], :name => "index_experiments_on_model_id"

  create_table "lines", :force => true do |t|
    t.float    "x"
    t.float    "y"
    t.float    "z"
    t.string   "note"
    t.integer  "measurement_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "ln_y"
    t.boolean  "regression_flag"
  end

  add_index "lines", ["measurement_id"], :name => "index_measurement_lines_on_measurement_id"

  create_table "measurements", :force => true do |t|
    t.text     "original_data"
    t.integer  "experiment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date"
    t.string   "title"
  end

  add_index "measurements", ["experiment_id"], :name => "index_measurements_on_experiment_id"

  create_table "models", :force => true do |t|
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  create_table "params", :force => true do |t|
    t.string   "code"
    t.string   "human_title"
    t.integer  "dyna_model_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  add_index "params", ["dyna_model_id"], :name => "index_params_on_dyna_model_id"

  create_table "proxy_dyna_models", :force => true do |t|
    t.integer  "measurement_id"
    t.integer  "experiment_id"
    t.integer  "dyna_model_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "json",           :limit => 2147483647
    t.float  "rmse"
    t.float  "bias"
    t.float  "accuracy"
  end

  add_index "proxy_dyna_models", ["dyna_model_id"], :name => "index_proxy_dyna_models_on_dyna_model_id"
  add_index "proxy_dyna_models", ["experiment_id"], :name => "index_proxy_dyna_models_on_experiment_id"
  add_index "proxy_dyna_models", ["measurement_id"], :name => "index_proxy_dyna_models_on_measurement_id"

  create_table "proxy_params", :force => true do |t|
    t.float    "value"
    t.integer  "proxy_dyna_model_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "param_id"
  end

  add_index "proxy_params", ["proxy_dyna_model_id"], :name => "index_proxy_params_on_proxy_dyna_model_id"

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
