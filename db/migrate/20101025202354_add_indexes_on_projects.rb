class AddIndexesOnProjects < ActiveRecord::Migration
  def self.up
    add_index :projects, [:account_id, :completed]
    add_index :projects, :account_id
    add_index :projects, [:completed, :updated_at]
  end

  def self.down
    remove_index :projects, [:account_id, :completed]
    remove_index :projects, :account_id
    remove_index :projects, [:completed, :updated_at]
  end
end
