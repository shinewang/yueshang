# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100313140319) do

  create_table "accounts", :force => true do |t|
    t.string   "login",                     :limit => 30
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.boolean  "enable",                                  :default => true
    t.string   "password_reset_code"
    t.datetime "password_reset_code_until"
  end

  create_table "accounts_roles", :id => false, :force => true do |t|
    t.integer  "role_id",    :limit => 11
    t.integer  "account_id", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts_roles", ["role_id"], :name => "index_accounts_roles_on_role_id"
  add_index "accounts_roles", ["account_id"], :name => "index_accounts_roles_on_account_id"

  create_table "admin_audits", :force => true do |t|
    t.integer  "account_id",  :limit => 11
    t.string   "ip"
    t.string   "module_name"
    t.string   "action"
    t.string   "record"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "parent_category_id", :limit => 11, :default => -1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.text     "introduction"
    t.string   "contact_person"
    t.string   "tel"
    t.string   "mobile"
    t.string   "email"
    t.string   "qq"
    t.string   "msn"
    t.string   "fax"
    t.string   "address"
    t.string   "zip"
    t.string   "site"
    t.text     "remark"
    t.integer  "category_id",    :limit => 11
    t.integer  "status",         :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_failures", :force => true do |t|
    t.string   "remote_ip"
    t.string   "http_user_agent"
    t.string   "failure_type"
    t.string   "username"
    t.integer  "count",           :limit => 11, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_failures", ["remote_ip"], :name => "index_user_failures_on_remote_ip"

end
