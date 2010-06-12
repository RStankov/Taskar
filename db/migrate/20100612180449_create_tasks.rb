class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.references :section
      t.text :text
      t.integer :status, :default => 0
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
