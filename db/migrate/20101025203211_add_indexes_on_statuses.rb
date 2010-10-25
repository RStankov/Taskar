class AddIndexesOnStatuses < ActiveRecord::Migration
  def self.up
    add_index :statuses, :user_id
    add_index :statuses, :project_id
  end

  def self.down
    remove_index :statuses, :user_id
    remove_index :statuses, :project_id
  end
end
