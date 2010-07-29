class AddStatusToProjectUsers < ActiveRecord::Migration
  def self.up
    add_column :project_users, :status, :string
  end

  def self.down
    remove_column :project_users, :status
  end
end
