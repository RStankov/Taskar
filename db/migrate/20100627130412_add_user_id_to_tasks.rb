class AddUserIdToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :user_id, :integer
    
    Task.update_all(:user_id => User.first.id) if User.first
  end

  def self.down
    remove_column :tasks, :user_id
  end
end
