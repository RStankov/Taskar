class AddIndexesForEvents < ActiveRecord::Migration
  def self.up
    add_index :events, [:project_id, :updated_at]
    add_index :events, [:user_id, :updated_at]
    add_index :events, [:subject_type, :subject_id]
  end

  def self.down
    remove_index :events, [:project_id, :updated_at]
    remove_index :events, [:user_id, :updated_at]
    remove_index :events, [:subject_type, :subject_id]
  end
end
