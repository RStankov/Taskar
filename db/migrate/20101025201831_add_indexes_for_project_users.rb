class AddIndexesForProjectUsers < ActiveRecord::Migration
  def self.up
    add_index :project_users, [:project_id, :user_id], :unique => true
    add_index :project_users, :project_id
    add_index :project_users, :user_id
  end

  def self.down
    remove_index :project_users, [:project_id, :user_id]
    remove_index :project_users, :project_id
    remove_index :project_users, :user_id
  end
end
