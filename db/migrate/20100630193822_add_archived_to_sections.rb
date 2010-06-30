class AddArchivedToSections < ActiveRecord::Migration
  def self.up
    add_column :sections, :archived, :boolean, :default => false
  end

  def self.down
    remove_column :sections, :archived
  end
end
