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

ActiveRecord::Schema.define(:version => 20120103172139) do

  create_table "experiments", :force => true do |t|
    t.text     "description"
    t.integer  "model_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  add_index "experiments", ["model_id"], :name => "index_experiments_on_model_id"

  create_table "lines", :force => true do |t|
    t.integer  "result_id"
    t.decimal  "time",       :precision => 15, :scale => 5
    t.decimal  "od600",      :precision => 15, :scale => 5
    t.decimal  "ln_od600",   :precision => 15, :scale => 5
    t.decimal  "ph",         :precision => 15, :scale => 5
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "regression"
  end

  add_index "lines", ["result_id"], :name => "index_lines_on_result_id"

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

  add_index "lines", ["measurement_id"], :name => "index_lines_on_measurement_id"

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

  create_table "results", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "original_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date"
  end

end
