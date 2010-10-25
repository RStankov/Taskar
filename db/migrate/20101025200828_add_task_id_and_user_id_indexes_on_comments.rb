class AddTaskIdAndUserIdIndexesOnComments < ActiveRecord::Migration
  def self.up
    add_index :comments, :task_id
    add_index :comments, :user_id
  end

  def self.down
    drop_index :comments, :task_id
    drop_index :comments, :user_id
  end
end
