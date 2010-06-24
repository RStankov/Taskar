class AddArchivedToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :archived, :boolean, :default => false
  end

  def self.down
    remove_column :tasks, :archived
  end
end
