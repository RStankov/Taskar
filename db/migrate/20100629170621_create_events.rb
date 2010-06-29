class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :subject_id
      t.string :subject_type
      t.string :action
      t.string :info

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
