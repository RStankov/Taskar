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

ActiveRecord::Schema.define(:version => 20100727233706) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["id"], :name => "index_accounts_on_id"

  create_table "comments", :force => true do |t|
    t.integer  "task_id"
    t.integer  "user_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end

  add_index "comments", ["id"], :name => "index_comments_on_id"

  create_table "events", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.string   "action"
    t.string   "info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["id"], :name => "index_events_on_id"
  add_index "events", ["subject_type"], :name => "index_events_on_subject_type"

  create_table "project_users", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_users", ["id"], :name => "index_project_users_on_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "completed",  :default => false
    t.integer  "account_id"
  end

  add_index "projects", ["id"], :name => "index_projects_on_id"

  create_table "sections", :force => true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archived",   :default => false
  end

  add_index "sections", ["id"], :name => "index_sections_on_id"

  create_table "statuses", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "statuses", ["project_id"], :name => "index_statuses_on_project_id"
  add_index "statuses", ["user_id", "project_id"], :name => "index_statuses_on_user_id_and_project_id"
  add_index "statuses", ["user_id"], :name => "index_statuses_on_user_id"

  create_table "tasks", :force => true do |t|
    t.integer  "section_id"
    t.text     "text"
    t.integer  "status",               :default => 0
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comments_count",       :default => 0
    t.boolean  "archived",             :default => false
    t.integer  "project_id"
    t.integer  "user_id"
    t.integer  "responsible_party_id"
  end

  add_index "tasks", ["id"], :name => "index_tasks_on_id"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "comments_count",                      :default => 0
    t.boolean  "admin"
    t.datetime "last_active_at"
    t.integer  "account_id"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
  end

  add_index "users", ["id"], :name => "index_users_on_id"

end
