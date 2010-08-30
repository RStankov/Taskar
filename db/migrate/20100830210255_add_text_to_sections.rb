class AddTextToSections < ActiveRecord::Migration
  def self.up
    add_column :sections, :text, :text
  end

  def self.down
    remove_column :sections, :text
  end
end
