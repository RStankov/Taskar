class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.integer :user_id
      t.integer :project_id
      t.text :text
      t.timestamps
    end
    
    add_index :statuses, :user_id
    add_index :statuses, :project_id
    add_index :statuses, [:user_id, :project_id]
  end

  def self.down
    drop_table :statuses
  end
end
