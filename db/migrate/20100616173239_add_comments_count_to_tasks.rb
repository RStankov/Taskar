class AddCommentsCountToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :comments_count, :integer, :default => 0
  end

  def self.down
    remove_column :tasks, :comments_count
  end
end
