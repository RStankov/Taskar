class AddArchivedToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :archived, :boolean
  end

  def self.down
    remove_column :tasks, :archived
  end
end
