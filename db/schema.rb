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

ActiveRecord::Schema.define(:version => 20120125220006) do

  create_table "account_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
  end

  add_index "account_users", ["account_id"], :name => "index_account_users_on_account_id"
  add_index "account_users", ["user_id"], :name => "index_account_users_on_user_id"

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["owner_id"], :name => "index_accounts_on_owner_id"

  create_table "comments", :force => true do |t|
    t.integer  "task_id"
    t.integer  "user_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end

  add_index "comments", ["task_id"], :name => "index_comments_on_task_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

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

  add_index "events", ["project_id", "updated_at"], :name => "index_events_on_project_id_and_updated_at"
  add_index "events", ["subject_type", "subject_id"], :name => "index_events_on_subject_type_and_subject_id"
  add_index "events", ["subject_type"], :name => "index_events_on_subject_type"
  add_index "events", ["user_id", "updated_at"], :name => "index_events_on_user_id_and_updated_at"

  create_table "invitations", :force => true do |t|
    t.integer  "account_id"
    t.string   "email"
    t.string   "token"
    t.datetime "send_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["account_id"], :name => "index_invitations_on_account_id"
  add_index "invitations", ["email"], :name => "index_invitations_on_email"
  add_index "invitations", ["token"], :name => "index_invitations_on_token"

  create_table "issues", :force => true do |t|
    t.integer  "user_id"
    t.string   "url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_users", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.datetime "last_seen_event_at"
  end

  add_index "project_users", ["project_id", "user_id"], :name => "index_project_users_on_project_id_and_user_id", :unique => true
  add_index "project_users", ["project_id"], :name => "index_project_users_on_project_id"
  add_index "project_users", ["user_id"], :name => "index_project_users_on_user_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "completed",  :default => false
    t.integer  "account_id"
  end

  add_index "projects", ["account_id", "completed"], :name => "index_projects_on_account_id_and_completed"
  add_index "projects", ["account_id"], :name => "index_projects_on_account_id"
  add_index "projects", ["completed", "updated_at"], :name => "index_projects_on_completed_and_updated_at"

  create_table "sections", :force => true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archived",   :default => false
    t.text     "text"
  end

  add_index "sections", ["archived"], :name => "index_sections_on_archived"
  add_index "sections", ["project_id", "position", "archived"], :name => "index_sections_on_project_id_and_position_and_archived"
  add_index "sections", ["project_id", "position"], :name => "index_sections_on_project_id_and_position"
  add_index "sections", ["project_id"], :name => "index_sections_on_project_id"

  create_table "statuses", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.text     "text"
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

  add_index "tasks", ["archived"], :name => "index_tasks_on_archived"
  add_index "tasks", ["project_id", "responsible_party_id", "status"], :name => "index_tasks_on_project_id_and_responsible_party_id_and_status"
  add_index "tasks", ["project_id", "status"], :name => "index_tasks_on_project_id_and_status"
  add_index "tasks", ["project_id"], :name => "index_tasks_on_project_id"
  add_index "tasks", ["responsible_party_id"], :name => "index_tasks_on_responsible_party_id"
  add_index "tasks", ["section_id", "archived", "position"], :name => "index_tasks_on_section_id_and_archived_and_position"
  add_index "tasks", ["section_id", "archived"], :name => "index_tasks_on_section_id_and_archived"
  add_index "tasks", ["section_id", "position"], :name => "index_tasks_on_section_id_and_position"
  add_index "tasks", ["section_id", "status"], :name => "index_tasks_on_section_id_and_status"
  add_index "tasks", ["section_id"], :name => "index_tasks_on_section_id"
  add_index "tasks", ["status"], :name => "index_tasks_on_status"
  add_index "tasks", ["user_id"], :name => "index_tasks_on_user_id"

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
    t.datetime "last_active_at"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email"

end
