class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.database_authenticatable
      t.recoverable
      t.rememberable
      t.trackable
      t.timestamps
      t.string :first_name
      t.string :last_name
    end
  end

  def self.down
    drop_table :users
  end
end
