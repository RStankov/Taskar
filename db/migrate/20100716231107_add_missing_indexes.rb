class AddMissingIndexes < ActiveRecord::Migration
  def self.up  
    add_index :comments, :id
    add_index :projects, :id
    add_index :events, :id
    add_index :events, :subject_type
    add_index :tasks, :id
    add_index :sections, :id
    add_index :project_users, :id
    add_index :accounts, :id
    add_index :users, :id
  end

  def self.down
    remove_index :comments, :id
    remove_index :projects, :id
    remove_index :events, :id
    remove_index :events, :subject_type
    remove_index :tasks, :id
    remove_index :sections, :id
    remove_index :project_users, :id
    remove_index :accounts, :id
    remove_index :users, :id
  end

end
