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

ActiveRecord::Schema.define(:version => 20120925110237) do

  create_table "accessibles", :force => true do |t|
    t.integer  "accessible_id"
    t.string   "accessible_type"
    t.integer  "group_id"
    t.integer  "permission_level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "dyna_models", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "definition"
    t.string   "solver"
    t.string   "estimation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.boolean  "only_owner_can_change"
  end

  create_table "experiments", :force => true do |t|
    t.text     "description"
    t.integer  "model_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  add_index "experiments", ["model_id"], :name => "index_experiments_on_model_id"

  create_table "groups", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.float    "minor_step"
  end

  add_index "measurements", ["experiment_id"], :name => "index_measurements_on_experiment_id"

  create_table "memberships", :force => true do |t|
    t.integer "user_id"
    t.integer "group_id"
  end

  create_table "models", :force => true do |t|
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.boolean  "is_published"
    t.integer  "owner_id"
  end

  create_table "params", :force => true do |t|
    t.string   "code"
    t.string   "human_title"
    t.integer  "dyna_model_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.float    "top"
    t.float    "bottom"
    t.boolean  "output_only"
    t.boolean  "initial_condition"
  end

  add_index "params", ["dyna_model_id"], :name => "index_params_on_dyna_model_id"

  create_table "proxy_dyna_models", :force => true do |t|
    t.integer  "measurement_id"
    t.integer  "experiment_id"
    t.integer  "dyna_model_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "json",           :limit => 2147483647
    t.float    "rmse"
    t.float    "bias"
    t.float    "accuracy"
    t.text     "notes"
    t.boolean  "no_death_phase"
    t.boolean  "log_flag"
    t.string   "title"
    t.float    "r_square"
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
    t.float    "top"
    t.float    "bottom"
  end

  add_index "proxy_params", ["proxy_dyna_model_id"], :name => "index_proxy_params_on_proxy_dyna_model_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

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
