class AddIndexesOnTasks < ActiveRecord::Migration
  def self.up
    add_index :tasks, [:project_id, :responsible_party_id, :status]
    add_index :tasks, [:project_id, :status]
    add_index :tasks, [:section_id, :status]
    add_index :tasks, [:section_id, :position]
    add_index :tasks, [:section_id, :archived]
    add_index :tasks, [:section_id, :archived, :position]
    add_index :tasks, :project_id
    add_index :tasks, :section_id
    add_index :tasks, :user_id
    add_index :tasks, :status
    add_index :tasks, :archived
    add_index :tasks, :responsible_party_id
  end

  def self.down
    remove_index :tasks, [:project_id, :responsible_party_id, :status]
    remove_index :tasks, [:project_id, :status]
    remove_index :tasks, [:section_id, :status]
    remove_index :tasks, [:section_id, :position]
    remove_index :tasks, [:section_id, :archived]
    remove_index :tasks, [:section_id, :archived, :position]
    remove_index :tasks, :project_id
    remove_index :tasks, :section_id
    remove_index :tasks, :user_id
    remove_index :tasks, :status
    remove_index :tasks, :archived
    remove_index :tasks, :responsible_party_id
  end
end
