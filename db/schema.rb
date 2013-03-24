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

ActiveRecord::Schema.define(:version => 20130324155417) do

  create_table "accessibles", :force => true do |t|
    t.integer  "permitable_id"
    t.string   "permitable_type"
    t.integer  "group_id"
    t.integer  "permission_level"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "blobs", :force => true do |t|
    t.binary   "data",          :limit => 16777215
    t.integer  "blobable_id"
    t.string   "blobable_type"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "blobs", ["blobable_id"], :name => "index_blobs_on_blobable_id"

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

  create_table "dyna_model_options", :force => true do |t|
    t.string   "name"
    t.float    "value"
    t.integer  "dyna_model_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "dyna_model_options", ["dyna_model_id"], :name => "index_dyna_model_options_on_dyna_model_id"

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
    t.boolean  "log_flag"
    t.string   "equation"
    t.integer  "eq_type"
    t.integer  "octave_model_id"
  end

  create_table "experiments", :force => true do |t|
    t.text     "description"
    t.integer  "model_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.boolean  "default"
  end

  add_index "experiments", ["model_id"], :name => "index_experiments_on_model_id"

  create_table "groups", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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

  add_index "lines", ["measurement_id", "x"], :name => "index_lines_on_measurement_id_and_x"

  create_table "measurements", :force => true do |t|
    t.text     "original_data"
    t.integer  "experiment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date"
    t.string   "title"
    t.float    "minor_step"
    t.text     "description"
    t.float    "regression_a"
    t.float    "regression_b"
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

  create_table "octave_models", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.string   "model_file_name"
    t.string   "model_content_type"
    t.integer  "model_file_size"
    t.datetime "model_updated_at"
    t.string   "solver_file_name"
    t.string   "solver_content_type"
    t.integer  "solver_file_size"
    t.datetime "solver_updated_at"
    t.string   "estimator_file_name"
    t.string   "estimator_content_type"
    t.integer  "estimator_file_size"
    t.datetime "estimator_updated_at"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "octave_models", ["user_id"], :name => "index_octave_models_on_user_id"

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
    t.float    "rmse"
    t.float    "bias"
    t.float    "accuracy"
    t.text     "notes"
    t.boolean  "no_death_phase"
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

  create_table "site_accesslog", :primary_key => "aid", :force => true do |t|
    t.string  "sid",       :limit => 128, :default => "", :null => false
    t.string  "title"
    t.string  "path"
    t.text    "url"
    t.string  "hostname",  :limit => 128
    t.integer "uid",                      :default => 0
    t.integer "timer",                    :default => 0,  :null => false
    t.integer "timestamp",                :default => 0,  :null => false
  end

  add_index "site_accesslog", ["timestamp"], :name => "accesslog_timestamp"
  add_index "site_accesslog", ["uid"], :name => "uid"

  create_table "site_actions", :primary_key => "aid", :force => true do |t|
    t.string "type",       :limit => 32,         :default => "",  :null => false
    t.string "callback",                         :default => "",  :null => false
    t.binary "parameters", :limit => 2147483647,                  :null => false
    t.string "label",                            :default => "0", :null => false
  end

  create_table "site_authmap", :primary_key => "aid", :force => true do |t|
    t.integer "uid",                     :default => 0,  :null => false
    t.string  "authname", :limit => 128, :default => "", :null => false
    t.string  "module",   :limit => 128, :default => "", :null => false
  end

  add_index "site_authmap", ["authname"], :name => "authname", :unique => true

  create_table "site_batch", :primary_key => "bid", :force => true do |t|
    t.string  "token",     :limit => 64,         :null => false
    t.integer "timestamp",                       :null => false
    t.binary  "batch",     :limit => 2147483647
  end

  add_index "site_batch", ["token"], :name => "token"

  create_table "site_block", :primary_key => "bid", :force => true do |t|
    t.string  "module",     :limit => 64, :default => "",  :null => false
    t.string  "delta",      :limit => 32, :default => "0", :null => false
    t.string  "theme",      :limit => 64, :default => "",  :null => false
    t.integer "status",     :limit => 1,  :default => 0,   :null => false
    t.integer "weight",                   :default => 0,   :null => false
    t.string  "region",     :limit => 64, :default => "",  :null => false
    t.integer "custom",     :limit => 1,  :default => 0,   :null => false
    t.integer "visibility", :limit => 1,  :default => 0,   :null => false
    t.text    "pages",                                     :null => false
    t.string  "title",      :limit => 64, :default => "",  :null => false
    t.integer "cache",      :limit => 1,  :default => 1,   :null => false
  end

  add_index "site_block", ["theme", "module", "delta"], :name => "tmd", :unique => true
  add_index "site_block", ["theme", "status", "region", "weight", "module"], :name => "list"

  create_table "site_block_custom", :primary_key => "bid", :force => true do |t|
    t.text   "body",   :limit => 2147483647
    t.string "info",   :limit => 128,        :default => "", :null => false
    t.string "format"
  end

  add_index "site_block_custom", ["info"], :name => "info", :unique => true

  create_table "site_block_node_type", :id => false, :force => true do |t|
    t.string "module", :limit => 64, :null => false
    t.string "delta",  :limit => 32, :null => false
    t.string "type",   :limit => 32, :null => false
  end

  add_index "site_block_node_type", ["type"], :name => "type"

  create_table "site_block_role", :id => false, :force => true do |t|
    t.string  "module", :limit => 64, :null => false
    t.string  "delta",  :limit => 32, :null => false
    t.integer "rid",                  :null => false
  end

  add_index "site_block_role", ["rid"], :name => "rid"

  create_table "site_blocked_ips", :primary_key => "iid", :force => true do |t|
    t.string "ip", :limit => 40, :default => "", :null => false
  end

  add_index "site_blocked_ips", ["ip"], :name => "blocked_ip"

  create_table "site_book", :primary_key => "mlid", :force => true do |t|
    t.integer "nid", :default => 0, :null => false
    t.integer "bid", :default => 0, :null => false
  end

  add_index "site_book", ["bid"], :name => "bid"
  add_index "site_book", ["nid"], :name => "nid", :unique => true

  create_table "site_cache", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 0, :null => false
  end

  add_index "site_cache", ["expire"], :name => "expire"

  create_table "site_cache_block", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 0, :null => false
  end

  add_index "site_cache_block", ["expire"], :name => "expire"

  create_table "site_cache_bootstrap", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 0, :null => false
  end

  add_index "site_cache_bootstrap", ["expire"], :name => "expire"

  create_table "site_cache_field", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 0, :null => false
  end

  add_index "site_cache_field", ["expire"], :name => "expire"

  create_table "site_cache_filter", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 0, :null => false
  end

  add_index "site_cache_filter", ["expire"], :name => "expire"

  create_table "site_cache_form", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 0, :null => false
  end

  add_index "site_cache_form", ["expire"], :name => "expire"

  create_table "site_cache_image", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 0, :null => false
  end

  add_index "site_cache_image", ["expire"], :name => "expire"

  create_table "site_cache_menu", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 0, :null => false
  end

  add_index "site_cache_menu", ["expire"], :name => "expire"

  create_table "site_cache_page", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 0, :null => false
  end

  add_index "site_cache_page", ["expire"], :name => "expire"

  create_table "site_cache_path", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 0, :null => false
  end

  add_index "site_cache_path", ["expire"], :name => "expire"

  create_table "site_cache_update", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 0, :null => false
  end

  add_index "site_cache_update", ["expire"], :name => "expire"

  create_table "site_cache_views", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 0, :null => false
  end

  add_index "site_cache_views", ["expire"], :name => "expire"

  create_table "site_cache_views_data", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 1, :null => false
  end

  add_index "site_cache_views_data", ["expire"], :name => "expire"

  create_table "site_comment", :primary_key => "cid", :force => true do |t|
    t.integer "pid",                     :default => 0,  :null => false
    t.integer "nid",                     :default => 0,  :null => false
    t.integer "uid",                     :default => 0,  :null => false
    t.string  "subject",  :limit => 64,  :default => "", :null => false
    t.string  "hostname", :limit => 128, :default => "", :null => false
    t.integer "created",                 :default => 0,  :null => false
    t.integer "changed",                 :default => 0,  :null => false
    t.integer "status",   :limit => 1,   :default => 1,  :null => false
    t.string  "thread",                                  :null => false
    t.string  "name",     :limit => 60
    t.string  "mail",     :limit => 64
    t.string  "homepage"
    t.string  "language", :limit => 12,  :default => "", :null => false
  end

  add_index "site_comment", ["nid", "language"], :name => "comment_nid_language"
  add_index "site_comment", ["nid", "status", "created", "cid", "thread"], :name => "comment_num_new"
  add_index "site_comment", ["pid", "status"], :name => "comment_status_pid"
  add_index "site_comment", ["uid"], :name => "comment_uid"

  create_table "site_ctools_css_cache", :primary_key => "cid", :force => true do |t|
    t.string  "filename"
    t.text    "css",      :limit => 2147483647
    t.integer "filter",   :limit => 1
  end

  create_table "site_ctools_object_cache", :id => false, :force => true do |t|
    t.string  "sid",     :limit => 64,                        :null => false
    t.string  "name",    :limit => 128,                       :null => false
    t.string  "obj",     :limit => 32,                        :null => false
    t.integer "updated",                       :default => 0, :null => false
    t.text    "data",    :limit => 2147483647
  end

  add_index "site_ctools_object_cache", ["updated"], :name => "updated"

  create_table "site_date_format_locale", :id => false, :force => true do |t|
    t.string "format",   :limit => 100, :null => false
    t.string "type",     :limit => 64,  :null => false
    t.string "language", :limit => 12,  :null => false
  end

  create_table "site_date_format_type", :primary_key => "type", :force => true do |t|
    t.string  "title",                              :null => false
    t.integer "locked", :limit => 1, :default => 0, :null => false
  end

  add_index "site_date_format_type", ["title"], :name => "title"

  create_table "site_date_formats", :primary_key => "dfid", :force => true do |t|
    t.string  "format", :limit => 100,                :null => false
    t.string  "type",   :limit => 64,                 :null => false
    t.integer "locked", :limit => 1,   :default => 0, :null => false
  end

  add_index "site_date_formats", ["format", "type"], :name => "formats", :unique => true

  create_table "site_field_config", :force => true do |t|
    t.string  "field_name",     :limit => 32,                         :null => false
    t.string  "type",           :limit => 128,                        :null => false
    t.string  "module",         :limit => 128,        :default => "", :null => false
    t.integer "active",         :limit => 1,          :default => 0,  :null => false
    t.string  "storage_type",   :limit => 128,                        :null => false
    t.string  "storage_module", :limit => 128,        :default => "", :null => false
    t.integer "storage_active", :limit => 1,          :default => 0,  :null => false
    t.integer "locked",         :limit => 1,          :default => 0,  :null => false
    t.binary  "data",           :limit => 2147483647,                 :null => false
    t.integer "cardinality",    :limit => 1,          :default => 0,  :null => false
    t.integer "translatable",   :limit => 1,          :default => 0,  :null => false
    t.integer "deleted",        :limit => 1,          :default => 0,  :null => false
  end

  add_index "site_field_config", ["active"], :name => "active"
  add_index "site_field_config", ["deleted"], :name => "deleted"
  add_index "site_field_config", ["field_name"], :name => "field_name"
  add_index "site_field_config", ["module"], :name => "module"
  add_index "site_field_config", ["storage_active"], :name => "storage_active"
  add_index "site_field_config", ["storage_module"], :name => "storage_module"
  add_index "site_field_config", ["storage_type"], :name => "storage_type"
  add_index "site_field_config", ["type"], :name => "type"

  create_table "site_field_config_entity_type", :primary_key => "etid", :force => true do |t|
    t.string "type", :limit => 128, :null => false
  end

  add_index "site_field_config_entity_type", ["type"], :name => "type", :unique => true

  create_table "site_field_config_instance", :force => true do |t|
    t.integer "field_id",                                          :null => false
    t.string  "field_name",  :limit => 32,         :default => "", :null => false
    t.string  "entity_type", :limit => 32,         :default => "", :null => false
    t.string  "bundle",      :limit => 128,        :default => "", :null => false
    t.binary  "data",        :limit => 2147483647,                 :null => false
    t.integer "deleted",     :limit => 1,          :default => 0,  :null => false
  end

  add_index "site_field_config_instance", ["deleted"], :name => "deleted"
  add_index "site_field_config_instance", ["field_name", "entity_type", "bundle"], :name => "field_name_bundle"

  create_table "site_field_data_body", :id => false, :force => true do |t|
    t.string  "bundle",       :limit => 128,        :default => "", :null => false
    t.integer "deleted",      :limit => 1,          :default => 0,  :null => false
    t.integer "entity_id",                                          :null => false
    t.integer "revision_id"
    t.string  "language",     :limit => 32,         :default => "", :null => false
    t.integer "delta",                                              :null => false
    t.text    "body_value",   :limit => 2147483647
    t.text    "body_summary", :limit => 2147483647
    t.string  "body_format"
    t.string  "entity_type",  :limit => 128,        :default => "", :null => false
  end

  add_index "site_field_data_body", ["body_format"], :name => "body_format"
  add_index "site_field_data_body", ["bundle"], :name => "bundle"
  add_index "site_field_data_body", ["deleted"], :name => "deleted"
  add_index "site_field_data_body", ["entity_id"], :name => "entity_id"
  add_index "site_field_data_body", ["entity_type"], :name => "entity_type"
  add_index "site_field_data_body", ["language"], :name => "language"
  add_index "site_field_data_body", ["revision_id"], :name => "revision_id"

  create_table "site_field_data_comment_body", :id => false, :force => true do |t|
    t.integer "etid",                                                      :null => false
    t.string  "bundle",              :limit => 128,        :default => "", :null => false
    t.integer "deleted",             :limit => 1,          :default => 0,  :null => false
    t.integer "entity_id",                                                 :null => false
    t.integer "revision_id"
    t.string  "language",            :limit => 32,         :default => "", :null => false
    t.integer "delta",                                                     :null => false
    t.text    "comment_body_value",  :limit => 2147483647
    t.string  "comment_body_format"
  end

  add_index "site_field_data_comment_body", ["bundle"], :name => "bundle"
  add_index "site_field_data_comment_body", ["comment_body_format"], :name => "comment_body_format"
  add_index "site_field_data_comment_body", ["deleted"], :name => "deleted"
  add_index "site_field_data_comment_body", ["entity_id"], :name => "entity_id"
  add_index "site_field_data_comment_body", ["etid"], :name => "etid"
  add_index "site_field_data_comment_body", ["language"], :name => "language"
  add_index "site_field_data_comment_body", ["revision_id"], :name => "revision_id"

  create_table "site_field_data_field_image", :id => false, :force => true do |t|
    t.string  "bundle",            :limit => 128, :default => "", :null => false
    t.integer "deleted",           :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                        :null => false
    t.integer "revision_id"
    t.string  "language",          :limit => 32,  :default => "", :null => false
    t.integer "delta",                                            :null => false
    t.integer "field_image_fid"
    t.string  "field_image_alt",   :limit => 128
    t.string  "field_image_title", :limit => 128
    t.string  "entity_type",       :limit => 128, :default => "", :null => false
  end

  add_index "site_field_data_field_image", ["bundle"], :name => "bundle"
  add_index "site_field_data_field_image", ["deleted"], :name => "deleted"
  add_index "site_field_data_field_image", ["entity_id"], :name => "entity_id"
  add_index "site_field_data_field_image", ["entity_type"], :name => "entity_type"
  add_index "site_field_data_field_image", ["field_image_fid"], :name => "field_image_fid"
  add_index "site_field_data_field_image", ["language"], :name => "language"
  add_index "site_field_data_field_image", ["revision_id"], :name => "revision_id"

  create_table "site_field_data_field_short", :id => false, :force => true do |t|
    t.string  "entity_type",        :limit => 128, :default => "", :null => false
    t.string  "bundle",             :limit => 128, :default => "", :null => false
    t.integer "deleted",            :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                         :null => false
    t.integer "revision_id"
    t.string  "language",           :limit => 32,  :default => "", :null => false
    t.integer "delta",                                             :null => false
    t.string  "field_short_value"
    t.string  "field_short_format"
  end

  add_index "site_field_data_field_short", ["bundle"], :name => "bundle"
  add_index "site_field_data_field_short", ["deleted"], :name => "deleted"
  add_index "site_field_data_field_short", ["entity_id"], :name => "entity_id"
  add_index "site_field_data_field_short", ["entity_type"], :name => "entity_type"
  add_index "site_field_data_field_short", ["field_short_format"], :name => "field_short_format"
  add_index "site_field_data_field_short", ["language"], :name => "language"
  add_index "site_field_data_field_short", ["revision_id"], :name => "revision_id"

  create_table "site_field_data_field_sidebar", :id => false, :force => true do |t|
    t.string  "entity_type",         :limit => 128,                                :default => "", :null => false
    t.string  "bundle",              :limit => 128,                                :default => "", :null => false
    t.integer "deleted",             :limit => 1,                                  :default => 0,  :null => false
    t.integer "entity_id",                                                                         :null => false
    t.integer "revision_id"
    t.string  "language",            :limit => 32,                                 :default => "", :null => false
    t.integer "delta",                                                                             :null => false
    t.decimal "field_sidebar_value",                :precision => 10, :scale => 0
  end

  add_index "site_field_data_field_sidebar", ["bundle"], :name => "bundle"
  add_index "site_field_data_field_sidebar", ["deleted"], :name => "deleted"
  add_index "site_field_data_field_sidebar", ["entity_id"], :name => "entity_id"
  add_index "site_field_data_field_sidebar", ["entity_type"], :name => "entity_type"
  add_index "site_field_data_field_sidebar", ["language"], :name => "language"
  add_index "site_field_data_field_sidebar", ["revision_id"], :name => "revision_id"

  create_table "site_field_data_field_static", :id => false, :force => true do |t|
    t.string  "entity_type",         :limit => 128, :default => "", :null => false
    t.string  "bundle",              :limit => 128, :default => "", :null => false
    t.integer "deleted",             :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                          :null => false
    t.integer "revision_id"
    t.string  "language",            :limit => 32,  :default => "", :null => false
    t.integer "delta",                                              :null => false
    t.string  "field_static_value"
    t.string  "field_static_format"
  end

  add_index "site_field_data_field_static", ["bundle"], :name => "bundle"
  add_index "site_field_data_field_static", ["deleted"], :name => "deleted"
  add_index "site_field_data_field_static", ["entity_id"], :name => "entity_id"
  add_index "site_field_data_field_static", ["entity_type"], :name => "entity_type"
  add_index "site_field_data_field_static", ["field_static_format"], :name => "field_static_format"
  add_index "site_field_data_field_static", ["language"], :name => "language"
  add_index "site_field_data_field_static", ["revision_id"], :name => "revision_id"

  create_table "site_field_data_meta_description", :id => false, :force => true do |t|
    t.string  "entity_type",                     :limit => 128, :default => "", :null => false
    t.string  "bundle",                          :limit => 128, :default => "", :null => false
    t.integer "deleted",                         :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                                      :null => false
    t.integer "revision_id"
    t.string  "language",                        :limit => 32,  :default => "", :null => false
    t.integer "delta",                                                          :null => false
    t.string  "meta_description_metatags_quick"
  end

  add_index "site_field_data_meta_description", ["bundle"], :name => "bundle"
  add_index "site_field_data_meta_description", ["deleted"], :name => "deleted"
  add_index "site_field_data_meta_description", ["entity_id"], :name => "entity_id"
  add_index "site_field_data_meta_description", ["entity_type"], :name => "entity_type"
  add_index "site_field_data_meta_description", ["language"], :name => "language"
  add_index "site_field_data_meta_description", ["revision_id"], :name => "revision_id"

  create_table "site_field_data_meta_keywords", :id => false, :force => true do |t|
    t.string  "entity_type",                  :limit => 128, :default => "", :null => false
    t.string  "bundle",                       :limit => 128, :default => "", :null => false
    t.integer "deleted",                      :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                                   :null => false
    t.integer "revision_id"
    t.string  "language",                     :limit => 32,  :default => "", :null => false
    t.integer "delta",                                                       :null => false
    t.string  "meta_keywords_metatags_quick"
  end

  add_index "site_field_data_meta_keywords", ["bundle"], :name => "bundle"
  add_index "site_field_data_meta_keywords", ["deleted"], :name => "deleted"
  add_index "site_field_data_meta_keywords", ["entity_id"], :name => "entity_id"
  add_index "site_field_data_meta_keywords", ["entity_type"], :name => "entity_type"
  add_index "site_field_data_meta_keywords", ["language"], :name => "language"
  add_index "site_field_data_meta_keywords", ["revision_id"], :name => "revision_id"

  create_table "site_field_revision_body", :id => false, :force => true do |t|
    t.string  "bundle",       :limit => 128,        :default => "", :null => false
    t.integer "deleted",      :limit => 1,          :default => 0,  :null => false
    t.integer "entity_id",                                          :null => false
    t.integer "revision_id",                                        :null => false
    t.string  "language",     :limit => 32,         :default => "", :null => false
    t.integer "delta",                                              :null => false
    t.text    "body_value",   :limit => 2147483647
    t.text    "body_summary", :limit => 2147483647
    t.string  "body_format"
    t.string  "entity_type",  :limit => 128,        :default => "", :null => false
  end

  add_index "site_field_revision_body", ["body_format"], :name => "body_format"
  add_index "site_field_revision_body", ["bundle"], :name => "bundle"
  add_index "site_field_revision_body", ["deleted"], :name => "deleted"
  add_index "site_field_revision_body", ["entity_id"], :name => "entity_id"
  add_index "site_field_revision_body", ["entity_type"], :name => "entity_type"
  add_index "site_field_revision_body", ["language"], :name => "language"
  add_index "site_field_revision_body", ["revision_id"], :name => "revision_id"

  create_table "site_field_revision_comment_body", :id => false, :force => true do |t|
    t.integer "etid",                                                      :null => false
    t.string  "bundle",              :limit => 128,        :default => "", :null => false
    t.integer "deleted",             :limit => 1,          :default => 0,  :null => false
    t.integer "entity_id",                                                 :null => false
    t.integer "revision_id",                                               :null => false
    t.string  "language",            :limit => 32,         :default => "", :null => false
    t.integer "delta",                                                     :null => false
    t.text    "comment_body_value",  :limit => 2147483647
    t.string  "comment_body_format"
  end

  add_index "site_field_revision_comment_body", ["bundle"], :name => "bundle"
  add_index "site_field_revision_comment_body", ["comment_body_format"], :name => "comment_body_format"
  add_index "site_field_revision_comment_body", ["deleted"], :name => "deleted"
  add_index "site_field_revision_comment_body", ["entity_id"], :name => "entity_id"
  add_index "site_field_revision_comment_body", ["etid"], :name => "etid"
  add_index "site_field_revision_comment_body", ["language"], :name => "language"
  add_index "site_field_revision_comment_body", ["revision_id"], :name => "revision_id"

  create_table "site_field_revision_field_image", :id => false, :force => true do |t|
    t.string  "bundle",            :limit => 128, :default => "", :null => false
    t.integer "deleted",           :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                        :null => false
    t.integer "revision_id",                                      :null => false
    t.string  "language",          :limit => 32,  :default => "", :null => false
    t.integer "delta",                                            :null => false
    t.integer "field_image_fid"
    t.string  "field_image_alt",   :limit => 128
    t.string  "field_image_title", :limit => 128
    t.string  "entity_type",       :limit => 128, :default => "", :null => false
  end

  add_index "site_field_revision_field_image", ["bundle"], :name => "bundle"
  add_index "site_field_revision_field_image", ["deleted"], :name => "deleted"
  add_index "site_field_revision_field_image", ["entity_id"], :name => "entity_id"
  add_index "site_field_revision_field_image", ["entity_type"], :name => "entity_type"
  add_index "site_field_revision_field_image", ["field_image_fid"], :name => "field_image_fid"
  add_index "site_field_revision_field_image", ["language"], :name => "language"
  add_index "site_field_revision_field_image", ["revision_id"], :name => "revision_id"

  create_table "site_field_revision_field_short", :id => false, :force => true do |t|
    t.string  "entity_type",        :limit => 128, :default => "", :null => false
    t.string  "bundle",             :limit => 128, :default => "", :null => false
    t.integer "deleted",            :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                         :null => false
    t.integer "revision_id",                                       :null => false
    t.string  "language",           :limit => 32,  :default => "", :null => false
    t.integer "delta",                                             :null => false
    t.string  "field_short_value"
    t.string  "field_short_format"
  end

  add_index "site_field_revision_field_short", ["bundle"], :name => "bundle"
  add_index "site_field_revision_field_short", ["deleted"], :name => "deleted"
  add_index "site_field_revision_field_short", ["entity_id"], :name => "entity_id"
  add_index "site_field_revision_field_short", ["entity_type"], :name => "entity_type"
  add_index "site_field_revision_field_short", ["field_short_format"], :name => "field_short_format"
  add_index "site_field_revision_field_short", ["language"], :name => "language"
  add_index "site_field_revision_field_short", ["revision_id"], :name => "revision_id"

  create_table "site_field_revision_field_sidebar", :id => false, :force => true do |t|
    t.string  "entity_type",         :limit => 128,                                :default => "", :null => false
    t.string  "bundle",              :limit => 128,                                :default => "", :null => false
    t.integer "deleted",             :limit => 1,                                  :default => 0,  :null => false
    t.integer "entity_id",                                                                         :null => false
    t.integer "revision_id",                                                                       :null => false
    t.string  "language",            :limit => 32,                                 :default => "", :null => false
    t.integer "delta",                                                                             :null => false
    t.decimal "field_sidebar_value",                :precision => 10, :scale => 0
  end

  add_index "site_field_revision_field_sidebar", ["bundle"], :name => "bundle"
  add_index "site_field_revision_field_sidebar", ["deleted"], :name => "deleted"
  add_index "site_field_revision_field_sidebar", ["entity_id"], :name => "entity_id"
  add_index "site_field_revision_field_sidebar", ["entity_type"], :name => "entity_type"
  add_index "site_field_revision_field_sidebar", ["language"], :name => "language"
  add_index "site_field_revision_field_sidebar", ["revision_id"], :name => "revision_id"

  create_table "site_field_revision_field_static", :id => false, :force => true do |t|
    t.string  "entity_type",         :limit => 128, :default => "", :null => false
    t.string  "bundle",              :limit => 128, :default => "", :null => false
    t.integer "deleted",             :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                          :null => false
    t.integer "revision_id",                                        :null => false
    t.string  "language",            :limit => 32,  :default => "", :null => false
    t.integer "delta",                                              :null => false
    t.string  "field_static_value"
    t.string  "field_static_format"
  end

  add_index "site_field_revision_field_static", ["bundle"], :name => "bundle"
  add_index "site_field_revision_field_static", ["deleted"], :name => "deleted"
  add_index "site_field_revision_field_static", ["entity_id"], :name => "entity_id"
  add_index "site_field_revision_field_static", ["entity_type"], :name => "entity_type"
  add_index "site_field_revision_field_static", ["field_static_format"], :name => "field_static_format"
  add_index "site_field_revision_field_static", ["language"], :name => "language"
  add_index "site_field_revision_field_static", ["revision_id"], :name => "revision_id"

  create_table "site_field_revision_meta_description", :id => false, :force => true do |t|
    t.string  "entity_type",                     :limit => 128, :default => "", :null => false
    t.string  "bundle",                          :limit => 128, :default => "", :null => false
    t.integer "deleted",                         :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                                      :null => false
    t.integer "revision_id",                                                    :null => false
    t.string  "language",                        :limit => 32,  :default => "", :null => false
    t.integer "delta",                                                          :null => false
    t.string  "meta_description_metatags_quick"
  end

  add_index "site_field_revision_meta_description", ["bundle"], :name => "bundle"
  add_index "site_field_revision_meta_description", ["deleted"], :name => "deleted"
  add_index "site_field_revision_meta_description", ["entity_id"], :name => "entity_id"
  add_index "site_field_revision_meta_description", ["entity_type"], :name => "entity_type"
  add_index "site_field_revision_meta_description", ["language"], :name => "language"
  add_index "site_field_revision_meta_description", ["revision_id"], :name => "revision_id"

  create_table "site_field_revision_meta_keywords", :id => false, :force => true do |t|
    t.string  "entity_type",                  :limit => 128, :default => "", :null => false
    t.string  "bundle",                       :limit => 128, :default => "", :null => false
    t.integer "deleted",                      :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                                   :null => false
    t.integer "revision_id",                                                 :null => false
    t.string  "language",                     :limit => 32,  :default => "", :null => false
    t.integer "delta",                                                       :null => false
    t.string  "meta_keywords_metatags_quick"
  end

  add_index "site_field_revision_meta_keywords", ["bundle"], :name => "bundle"
  add_index "site_field_revision_meta_keywords", ["deleted"], :name => "deleted"
  add_index "site_field_revision_meta_keywords", ["entity_id"], :name => "entity_id"
  add_index "site_field_revision_meta_keywords", ["entity_type"], :name => "entity_type"
  add_index "site_field_revision_meta_keywords", ["language"], :name => "language"
  add_index "site_field_revision_meta_keywords", ["revision_id"], :name => "revision_id"

  create_table "site_file_managed", :primary_key => "fid", :force => true do |t|
    t.integer "uid",                    :default => 0,  :null => false
    t.string  "filename",               :default => "", :null => false
    t.string  "uri",                    :default => "", :null => false
    t.string  "filemime",               :default => "", :null => false
    t.integer "filesize",               :default => 0,  :null => false
    t.integer "status",    :limit => 1, :default => 0,  :null => false
    t.integer "timestamp",              :default => 0,  :null => false
  end

  add_index "site_file_managed", ["status"], :name => "status"
  add_index "site_file_managed", ["timestamp"], :name => "timestamp"
  add_index "site_file_managed", ["uid"], :name => "uid"
  add_index "site_file_managed", ["uri"], :name => "uri", :unique => true

  create_table "site_file_usage", :id => false, :force => true do |t|
    t.integer "fid",                                  :null => false
    t.string  "module",               :default => "", :null => false
    t.string  "type",   :limit => 64, :default => "", :null => false
    t.integer "id",                   :default => 0,  :null => false
    t.integer "count",                :default => 0,  :null => false
  end

  add_index "site_file_usage", ["fid", "count"], :name => "fid_count"
  add_index "site_file_usage", ["fid", "module"], :name => "fid_module"
  add_index "site_file_usage", ["type", "id"], :name => "type_id"

  create_table "site_filter", :id => false, :force => true do |t|
    t.string  "format",                                         :null => false
    t.string  "module",   :limit => 64,         :default => "", :null => false
    t.string  "name",     :limit => 32,         :default => "", :null => false
    t.integer "weight",                         :default => 0,  :null => false
    t.integer "status",                         :default => 0,  :null => false
    t.binary  "settings", :limit => 2147483647
  end

  add_index "site_filter", ["weight", "module", "name"], :name => "list"

  create_table "site_filter_format", :primary_key => "format", :force => true do |t|
    t.string  "name",                :default => "", :null => false
    t.integer "cache",  :limit => 1, :default => 0,  :null => false
    t.integer "status", :limit => 1, :default => 1,  :null => false
    t.integer "weight",              :default => 0,  :null => false
  end

  add_index "site_filter_format", ["name"], :name => "name", :unique => true
  add_index "site_filter_format", ["status", "weight"], :name => "status_weight"

  create_table "site_flood", :primary_key => "fid", :force => true do |t|
    t.string  "event",      :limit => 64,  :default => "", :null => false
    t.string  "identifier", :limit => 128, :default => "", :null => false
    t.integer "timestamp",                 :default => 0,  :null => false
    t.integer "expiration",                :default => 0,  :null => false
  end

  add_index "site_flood", ["event", "identifier", "timestamp"], :name => "allow"
  add_index "site_flood", ["expiration"], :name => "purge"

  create_table "site_history", :id => false, :force => true do |t|
    t.integer "uid",       :default => 0, :null => false
    t.integer "nid",       :default => 0, :null => false
    t.integer "timestamp", :default => 0, :null => false
  end

  add_index "site_history", ["nid"], :name => "nid"

  create_table "site_image_effects", :primary_key => "ieid", :force => true do |t|
    t.integer "isid",                         :default => 0, :null => false
    t.integer "weight",                       :default => 0, :null => false
    t.string  "name",                                        :null => false
    t.binary  "data",   :limit => 2147483647,                :null => false
  end

  add_index "site_image_effects", ["isid"], :name => "isid"
  add_index "site_image_effects", ["weight"], :name => "weight"

  create_table "site_image_styles", :primary_key => "isid", :force => true do |t|
    t.string "name", :null => false
  end

  add_index "site_image_styles", ["name"], :name => "name", :unique => true

  create_table "site_languages", :primary_key => "language", :force => true do |t|
    t.string  "name",       :limit => 64,  :default => "", :null => false
    t.string  "native",     :limit => 64,  :default => "", :null => false
    t.integer "direction",                 :default => 0,  :null => false
    t.integer "enabled",                   :default => 0,  :null => false
    t.integer "plurals",                   :default => 0,  :null => false
    t.string  "formula",    :limit => 128, :default => "", :null => false
    t.string  "domain",     :limit => 128, :default => "", :null => false
    t.string  "prefix",     :limit => 128, :default => "", :null => false
    t.integer "weight",                    :default => 0,  :null => false
    t.string  "javascript", :limit => 64,  :default => "", :null => false
  end

  add_index "site_languages", ["weight", "name"], :name => "list"

  create_table "site_locales_source", :primary_key => "lid", :force => true do |t|
    t.text   "location",  :limit => 2147483647
    t.string "textgroup",                       :default => "default", :null => false
    t.binary "source",                                                 :null => false
    t.string "context",                         :default => "",        :null => false
    t.string "version",   :limit => 20,         :default => "none",    :null => false
  end

  add_index "site_locales_source", ["source", "context"], :name => "source_context", :length => {"source"=>30, "context"=>nil}

  create_table "site_locales_target", :id => false, :force => true do |t|
    t.integer "lid",                       :default => 0,  :null => false
    t.binary  "translation",                               :null => false
    t.string  "language",    :limit => 12, :default => "", :null => false
    t.integer "plid",                      :default => 0,  :null => false
    t.integer "plural",                    :default => 0,  :null => false
  end

  add_index "site_locales_target", ["lid"], :name => "lid"
  add_index "site_locales_target", ["plid"], :name => "plid"
  add_index "site_locales_target", ["plural"], :name => "plural"

  create_table "site_menu_custom", :primary_key => "menu_name", :force => true do |t|
    t.string "title",       :default => "", :null => false
    t.text   "description"
  end

  create_table "site_menu_links", :primary_key => "mlid", :force => true do |t|
    t.string  "menu_name",    :limit => 32, :default => "",       :null => false
    t.integer "plid",                       :default => 0,        :null => false
    t.string  "link_path",                  :default => "",       :null => false
    t.string  "router_path",                :default => "",       :null => false
    t.string  "link_title",                 :default => "",       :null => false
    t.binary  "options"
    t.string  "module",                     :default => "system", :null => false
    t.integer "hidden",       :limit => 2,  :default => 0,        :null => false
    t.integer "external",     :limit => 2,  :default => 0,        :null => false
    t.integer "has_children", :limit => 2,  :default => 0,        :null => false
    t.integer "expanded",     :limit => 2,  :default => 0,        :null => false
    t.integer "weight",                     :default => 0,        :null => false
    t.integer "depth",        :limit => 2,  :default => 0,        :null => false
    t.integer "customized",   :limit => 2,  :default => 0,        :null => false
    t.integer "p1",                         :default => 0,        :null => false
    t.integer "p2",                         :default => 0,        :null => false
    t.integer "p3",                         :default => 0,        :null => false
    t.integer "p4",                         :default => 0,        :null => false
    t.integer "p5",                         :default => 0,        :null => false
    t.integer "p6",                         :default => 0,        :null => false
    t.integer "p7",                         :default => 0,        :null => false
    t.integer "p8",                         :default => 0,        :null => false
    t.integer "p9",                         :default => 0,        :null => false
    t.integer "updated",      :limit => 2,  :default => 0,        :null => false
  end

  add_index "site_menu_links", ["link_path", "menu_name"], :name => "path_menu", :length => {"link_path"=>128, "menu_name"=>nil}
  add_index "site_menu_links", ["menu_name", "p1", "p2", "p3", "p4", "p5", "p6", "p7", "p8", "p9"], :name => "menu_parents"
  add_index "site_menu_links", ["menu_name", "plid", "expanded", "has_children"], :name => "menu_plid_expand_child"
  add_index "site_menu_links", ["router_path"], :name => "router_path", :length => {"router_path"=>128}

  create_table "site_menu_router", :primary_key => "path", :force => true do |t|
    t.binary  "load_functions",                                        :null => false
    t.binary  "to_arg_functions",                                      :null => false
    t.string  "access_callback",                       :default => "", :null => false
    t.binary  "access_arguments"
    t.string  "page_callback",                         :default => "", :null => false
    t.binary  "page_arguments"
    t.string  "delivery_callback",                     :default => "", :null => false
    t.integer "fit",                                   :default => 0,  :null => false
    t.integer "number_parts",      :limit => 2,        :default => 0,  :null => false
    t.integer "context",                               :default => 0,  :null => false
    t.string  "tab_parent",                            :default => "", :null => false
    t.string  "tab_root",                              :default => "", :null => false
    t.string  "title",                                 :default => "", :null => false
    t.string  "title_callback",                        :default => "", :null => false
    t.string  "title_arguments",                       :default => "", :null => false
    t.string  "theme_callback",                        :default => "", :null => false
    t.string  "theme_arguments",                       :default => "", :null => false
    t.integer "type",                                  :default => 0,  :null => false
    t.text    "description",                                           :null => false
    t.string  "position",                              :default => "", :null => false
    t.integer "weight",                                :default => 0,  :null => false
    t.text    "include_file",      :limit => 16777215
  end

  add_index "site_menu_router", ["fit"], :name => "fit"
  add_index "site_menu_router", ["tab_parent", "weight", "title"], :name => "tab_parent", :length => {"tab_parent"=>64, "weight"=>nil, "title"=>nil}
  add_index "site_menu_router", ["tab_root", "weight", "title"], :name => "tab_root_weight_title", :length => {"tab_root"=>64, "weight"=>nil, "title"=>nil}

  create_table "site_metatags_quick_path_based", :id => false, :force => true do |t|
    t.integer "id",                :null => false
    t.string  "path",              :null => false
    t.string  "lang", :limit => 8, :null => false
  end

  create_table "site_node", :primary_key => "nid", :force => true do |t|
    t.integer "vid",                     :default => 0,  :null => false
    t.string  "type",      :limit => 32, :default => "", :null => false
    t.string  "language",  :limit => 12, :default => "", :null => false
    t.string  "title",                   :default => "", :null => false
    t.integer "uid",                     :default => 0,  :null => false
    t.integer "status",                  :default => 1,  :null => false
    t.integer "created",                 :default => 0,  :null => false
    t.integer "changed",                 :default => 0,  :null => false
    t.integer "comment",                 :default => 0,  :null => false
    t.integer "promote",                 :default => 0,  :null => false
    t.integer "sticky",                  :default => 0,  :null => false
    t.integer "tnid",                    :default => 0,  :null => false
    t.integer "translate",               :default => 0,  :null => false
  end

  add_index "site_node", ["changed"], :name => "node_changed"
  add_index "site_node", ["created"], :name => "node_created"
  add_index "site_node", ["promote", "status", "sticky", "created"], :name => "node_frontpage"
  add_index "site_node", ["status", "type", "nid"], :name => "node_status_type"
  add_index "site_node", ["title", "type"], :name => "node_title_type", :length => {"title"=>nil, "type"=>4}
  add_index "site_node", ["tnid"], :name => "tnid"
  add_index "site_node", ["translate"], :name => "translate"
  add_index "site_node", ["type"], :name => "node_type", :length => {"type"=>4}
  add_index "site_node", ["uid"], :name => "uid"
  add_index "site_node", ["vid"], :name => "vid", :unique => true

  create_table "site_node_access", :id => false, :force => true do |t|
    t.integer "nid",                       :default => 0,  :null => false
    t.integer "gid",                       :default => 0,  :null => false
    t.string  "realm",                     :default => "", :null => false
    t.integer "grant_view",   :limit => 1, :default => 0,  :null => false
    t.integer "grant_update", :limit => 1, :default => 0,  :null => false
    t.integer "grant_delete", :limit => 1, :default => 0,  :null => false
  end

  create_table "site_node_comment_statistics", :primary_key => "nid", :force => true do |t|
    t.integer "cid",                                  :default => 0, :null => false
    t.integer "last_comment_timestamp",               :default => 0, :null => false
    t.string  "last_comment_name",      :limit => 60
    t.integer "last_comment_uid",                     :default => 0, :null => false
    t.integer "comment_count",                        :default => 0, :null => false
  end

  add_index "site_node_comment_statistics", ["comment_count"], :name => "comment_count"
  add_index "site_node_comment_statistics", ["last_comment_timestamp"], :name => "node_comment_timestamp"
  add_index "site_node_comment_statistics", ["last_comment_uid"], :name => "last_comment_uid"

  create_table "site_node_counter", :primary_key => "nid", :force => true do |t|
    t.integer "totalcount", :limit => 8, :default => 0, :null => false
    t.integer "daycount",   :limit => 3, :default => 0, :null => false
    t.integer "timestamp",               :default => 0, :null => false
  end

  create_table "site_node_revision", :primary_key => "vid", :force => true do |t|
    t.integer "nid",                             :default => 0,  :null => false
    t.integer "uid",                             :default => 0,  :null => false
    t.string  "title",                           :default => "", :null => false
    t.text    "log",       :limit => 2147483647,                 :null => false
    t.integer "timestamp",                       :default => 0,  :null => false
    t.integer "status",                          :default => 1,  :null => false
    t.integer "comment",                         :default => 0,  :null => false
    t.integer "promote",                         :default => 0,  :null => false
    t.integer "sticky",                          :default => 0,  :null => false
  end

  add_index "site_node_revision", ["nid"], :name => "nid"
  add_index "site_node_revision", ["uid"], :name => "uid"

  create_table "site_node_type", :primary_key => "type", :force => true do |t|
    t.string  "name",                            :default => "", :null => false
    t.string  "base",                                            :null => false
    t.string  "module",                                          :null => false
    t.text    "description", :limit => 16777215,                 :null => false
    t.text    "help",        :limit => 16777215,                 :null => false
    t.integer "has_title",   :limit => 1,                        :null => false
    t.string  "title_label",                     :default => "", :null => false
    t.integer "custom",      :limit => 1,        :default => 0,  :null => false
    t.integer "modified",    :limit => 1,        :default => 0,  :null => false
    t.integer "locked",      :limit => 1,        :default => 0,  :null => false
    t.integer "disabled",    :limit => 1,        :default => 0,  :null => false
    t.string  "orig_type",                       :default => "", :null => false
  end

  create_table "site_queue", :primary_key => "item_id", :force => true do |t|
    t.string  "name",                          :default => "", :null => false
    t.binary  "data",    :limit => 2147483647
    t.integer "expire",                        :default => 0,  :null => false
    t.integer "created",                       :default => 0,  :null => false
  end

  add_index "site_queue", ["expire"], :name => "expire"
  add_index "site_queue", ["name", "created"], :name => "name_created"

  create_table "site_rdf_mapping", :id => false, :force => true do |t|
    t.string "type",    :limit => 128,        :null => false
    t.string "bundle",  :limit => 128,        :null => false
    t.binary "mapping", :limit => 2147483647
  end

  create_table "site_redirect", :primary_key => "rid", :force => true do |t|
    t.string  "hash",             :limit => 64,                    :null => false
    t.string  "type",             :limit => 64, :default => "",    :null => false
    t.integer "uid",                            :default => 0,     :null => false
    t.string  "source",                                            :null => false
    t.text    "source_options",                                    :null => false
    t.string  "redirect",                                          :null => false
    t.text    "redirect_options",                                  :null => false
    t.string  "language",         :limit => 12, :default => "und", :null => false
    t.integer "status_code",      :limit => 2,                     :null => false
    t.integer "count",                          :default => 0,     :null => false
    t.integer "access",                         :default => 0,     :null => false
  end

  add_index "site_redirect", ["hash"], :name => "hash", :unique => true
  add_index "site_redirect", ["source", "language"], :name => "source_language"
  add_index "site_redirect", ["type", "access"], :name => "expires"

  create_table "site_registry", :id => false, :force => true do |t|
    t.string  "name",                  :default => "", :null => false
    t.string  "type",     :limit => 9, :default => "", :null => false
    t.string  "filename",                              :null => false
    t.string  "module",                :default => "", :null => false
    t.integer "weight",                :default => 0,  :null => false
  end

  add_index "site_registry", ["type", "weight", "module"], :name => "hook"

  create_table "site_registry_file", :primary_key => "filename", :force => true do |t|
    t.string "hash", :limit => 64, :null => false
  end

  create_table "site_role", :primary_key => "rid", :force => true do |t|
    t.string  "name",   :limit => 64, :default => "", :null => false
    t.integer "weight",               :default => 0,  :null => false
  end

  add_index "site_role", ["name", "weight"], :name => "name_weight"
  add_index "site_role", ["name"], :name => "name", :unique => true

  create_table "site_role_permission", :id => false, :force => true do |t|
    t.integer "rid",                                       :null => false
    t.string  "permission", :limit => 128, :default => "", :null => false
    t.string  "module",                    :default => "", :null => false
  end

  add_index "site_role_permission", ["permission"], :name => "permission"

  create_table "site_search_dataset", :id => false, :force => true do |t|
    t.integer "sid",                           :default => 0, :null => false
    t.string  "type",    :limit => 16,                        :null => false
    t.text    "data",    :limit => 2147483647,                :null => false
    t.integer "reindex",                       :default => 0, :null => false
  end

  create_table "site_search_index", :id => false, :force => true do |t|
    t.string  "word",  :limit => 50, :default => "", :null => false
    t.integer "sid",                 :default => 0,  :null => false
    t.string  "type",  :limit => 16,                 :null => false
    t.float   "score"
  end

  add_index "site_search_index", ["sid", "type"], :name => "sid_type"

  create_table "site_search_node_links", :id => false, :force => true do |t|
    t.integer "sid",                           :default => 0,  :null => false
    t.string  "type",    :limit => 16,         :default => "", :null => false
    t.integer "nid",                           :default => 0,  :null => false
    t.text    "caption", :limit => 2147483647
  end

  add_index "site_search_node_links", ["nid"], :name => "nid"

  create_table "site_search_total", :primary_key => "word", :force => true do |t|
    t.float "count"
  end

  create_table "site_semaphore", :primary_key => "name", :force => true do |t|
    t.string "value",  :default => "", :null => false
    t.float  "expire",                 :null => false
  end

  add_index "site_semaphore", ["expire"], :name => "expire"
  add_index "site_semaphore", ["value"], :name => "value"

  create_table "site_sequences", :primary_key => "value", :force => true do |t|
  end

  create_table "site_sessions", :id => false, :force => true do |t|
    t.integer "uid",                                             :null => false
    t.string  "sid",       :limit => 128,                        :null => false
    t.string  "ssid",      :limit => 128,        :default => "", :null => false
    t.string  "hostname",  :limit => 128,        :default => "", :null => false
    t.integer "timestamp",                       :default => 0,  :null => false
    t.integer "cache",                           :default => 0,  :null => false
    t.binary  "session",   :limit => 2147483647
  end

  add_index "site_sessions", ["ssid"], :name => "ssid"
  add_index "site_sessions", ["timestamp"], :name => "timestamp"
  add_index "site_sessions", ["uid"], :name => "uid"

  create_table "site_system", :primary_key => "filename", :force => true do |t|
    t.string  "name",                         :default => "", :null => false
    t.string  "type",           :limit => 12, :default => "", :null => false
    t.string  "owner",                        :default => "", :null => false
    t.integer "status",                       :default => 0,  :null => false
    t.integer "bootstrap",                    :default => 0,  :null => false
    t.integer "schema_version", :limit => 2,  :default => -1, :null => false
    t.integer "weight",                       :default => 0,  :null => false
    t.binary  "info"
  end

  add_index "site_system", ["status", "bootstrap", "type", "weight", "name"], :name => "system_list"
  add_index "site_system", ["type", "name"], :name => "type_name"

  create_table "site_taxonomy_index", :id => false, :force => true do |t|
    t.integer "nid",                  :default => 0, :null => false
    t.integer "tid",                  :default => 0, :null => false
    t.integer "sticky",  :limit => 1, :default => 0
    t.integer "created",              :default => 0, :null => false
  end

  add_index "site_taxonomy_index", ["nid"], :name => "nid"
  add_index "site_taxonomy_index", ["tid", "sticky", "created"], :name => "term_node"

  create_table "site_taxonomy_term_data", :primary_key => "tid", :force => true do |t|
    t.integer "vid",                               :default => 0,  :null => false
    t.string  "name",                              :default => "", :null => false
    t.text    "description", :limit => 2147483647
    t.string  "format"
    t.integer "weight",                            :default => 0,  :null => false
  end

  add_index "site_taxonomy_term_data", ["name"], :name => "name"
  add_index "site_taxonomy_term_data", ["vid", "name"], :name => "vid_name"
  add_index "site_taxonomy_term_data", ["vid", "weight", "name"], :name => "taxonomy_tree"

  create_table "site_taxonomy_term_hierarchy", :id => false, :force => true do |t|
    t.integer "tid",    :default => 0, :null => false
    t.integer "parent", :default => 0, :null => false
  end

  add_index "site_taxonomy_term_hierarchy", ["parent"], :name => "parent"

  create_table "site_taxonomy_vocabulary", :primary_key => "vid", :force => true do |t|
    t.string  "name",                               :default => "", :null => false
    t.string  "machine_name",                       :default => "", :null => false
    t.text    "description",  :limit => 2147483647
    t.integer "hierarchy",    :limit => 1,          :default => 0,  :null => false
    t.string  "module",                             :default => "", :null => false
    t.integer "weight",                             :default => 0,  :null => false
  end

  add_index "site_taxonomy_vocabulary", ["machine_name"], :name => "machine_name", :unique => true
  add_index "site_taxonomy_vocabulary", ["weight", "name"], :name => "list"

  create_table "site_url_alias", :primary_key => "pid", :force => true do |t|
    t.string "source",                 :default => "", :null => false
    t.string "alias",                  :default => "", :null => false
    t.string "language", :limit => 12, :default => "", :null => false
  end

  add_index "site_url_alias", ["alias", "language", "pid"], :name => "alias_language_pid"
  add_index "site_url_alias", ["source", "language", "pid"], :name => "source_language_pid"

  create_table "site_users", :primary_key => "uid", :force => true do |t|
    t.string  "name",             :limit => 60,         :default => "", :null => false
    t.string  "pass",             :limit => 128,        :default => "", :null => false
    t.string  "mail",             :limit => 254,        :default => ""
    t.string  "theme",                                  :default => "", :null => false
    t.string  "signature",                              :default => "", :null => false
    t.string  "signature_format"
    t.integer "created",                                :default => 0,  :null => false
    t.integer "access",                                 :default => 0,  :null => false
    t.integer "login",                                  :default => 0,  :null => false
    t.integer "status",           :limit => 1,          :default => 0,  :null => false
    t.string  "timezone",         :limit => 32
    t.string  "language",         :limit => 12,         :default => "", :null => false
    t.integer "picture",                                :default => 0,  :null => false
    t.string  "init",             :limit => 254,        :default => ""
    t.binary  "data",             :limit => 2147483647
  end

  add_index "site_users", ["access"], :name => "access"
  add_index "site_users", ["created"], :name => "created"
  add_index "site_users", ["mail"], :name => "mail"
  add_index "site_users", ["name"], :name => "name", :unique => true

  create_table "site_users_roles", :id => false, :force => true do |t|
    t.integer "uid", :default => 0, :null => false
    t.integer "rid", :default => 0, :null => false
  end

  add_index "site_users_roles", ["rid"], :name => "rid"

  create_table "site_variable", :primary_key => "name", :force => true do |t|
    t.binary "value", :limit => 2147483647, :null => false
  end

  create_table "site_views_display", :id => false, :force => true do |t|
    t.integer "vid",                                   :default => 0,  :null => false
    t.string  "id",              :limit => 64,         :default => "", :null => false
    t.string  "display_title",   :limit => 64,         :default => "", :null => false
    t.string  "display_plugin",  :limit => 64,         :default => "", :null => false
    t.integer "position",                              :default => 0
    t.text    "display_options", :limit => 2147483647
  end

  add_index "site_views_display", ["vid", "position"], :name => "vid"

  create_table "site_views_view", :primary_key => "vid", :force => true do |t|
    t.string  "name",        :limit => 128, :default => "", :null => false
    t.string  "description",                :default => ""
    t.string  "tag",                        :default => ""
    t.string  "base_table",  :limit => 64,  :default => "", :null => false
    t.string  "human_name",                 :default => ""
    t.integer "core",                       :default => 0
  end

  add_index "site_views_view", ["name"], :name => "name", :unique => true

  create_table "site_watchdog", :primary_key => "wid", :force => true do |t|
    t.integer "uid",                             :default => 0,  :null => false
    t.string  "type",      :limit => 64,         :default => "", :null => false
    t.text    "message",   :limit => 2147483647,                 :null => false
    t.binary  "variables", :limit => 2147483647,                 :null => false
    t.integer "severity",  :limit => 1,          :default => 0,  :null => false
    t.string  "link",                            :default => ""
    t.text    "location",                                        :null => false
    t.text    "referer"
    t.string  "hostname",  :limit => 128,        :default => "", :null => false
    t.integer "timestamp",                       :default => 0,  :null => false
  end

  add_index "site_watchdog", ["type"], :name => "type"
  add_index "site_watchdog", ["uid"], :name => "uid"

  create_table "site_wysiwyg", :primary_key => "format", :force => true do |t|
    t.string "editor",   :limit => 128, :default => "", :null => false
    t.text   "settings"
  end

  create_table "site_wysiwyg_user", :id => false, :force => true do |t|
    t.integer "uid",                 :default => 0, :null => false
    t.string  "format"
    t.integer "status", :limit => 1, :default => 0, :null => false
  end

  add_index "site_wysiwyg_user", ["format"], :name => "format"
  add_index "site_wysiwyg_user", ["uid"], :name => "uid"

  create_table "site_xmlsitemap", :id => false, :force => true do |t|
    t.integer "id",                               :default => 0,  :null => false
    t.string  "type",              :limit => 32,  :default => "", :null => false
    t.string  "subtype",           :limit => 128, :default => "", :null => false
    t.string  "loc",                              :default => "", :null => false
    t.string  "language",          :limit => 12,  :default => "", :null => false
    t.integer "access",            :limit => 1,   :default => 1,  :null => false
    t.integer "status",            :limit => 1,   :default => 1,  :null => false
    t.integer "status_override",   :limit => 1,   :default => 0,  :null => false
    t.integer "lastmod",                          :default => 0,  :null => false
    t.float   "priority"
    t.integer "priority_override", :limit => 1,   :default => 0,  :null => false
    t.integer "changefreq",                       :default => 0,  :null => false
    t.integer "changecount",                      :default => 0,  :null => false
  end

  add_index "site_xmlsitemap", ["access", "status", "loc"], :name => "access_status_loc"
  add_index "site_xmlsitemap", ["language"], :name => "language"
  add_index "site_xmlsitemap", ["loc"], :name => "loc"
  add_index "site_xmlsitemap", ["type", "subtype"], :name => "type_subtype"

  create_table "site_xmlsitemap_sitemap", :primary_key => "smid", :force => true do |t|
    t.text    "context",                     :null => false
    t.integer "updated",      :default => 0, :null => false
    t.integer "links",        :default => 0, :null => false
    t.integer "chunks",       :default => 0, :null => false
    t.integer "max_filesize", :default => 0, :null => false
  end

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
    t.boolean  "admin"
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
