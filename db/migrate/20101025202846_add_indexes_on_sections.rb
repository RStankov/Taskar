class AddIndexesOnSections < ActiveRecord::Migration
  def self.up
    add_index :sections, [:project_id, :position, :archived]
    add_index :sections, [:project_id, :position]
    add_index :sections, :project_id
    add_index :sections, :archived
  end

  def self.down
    drop_index :sections, [:project_id, :position, :archived]
    drop_index :sections, [:project_id, :position]
    drop_index :sections, :project_id
    drop_index :sections, :archived
  end
end
