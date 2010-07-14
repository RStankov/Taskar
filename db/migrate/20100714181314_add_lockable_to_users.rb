class AddLockableToUsers < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
       t.lockable
     end
  end

  def self.down
    remove_column :users, :failed_attempts
    remove_column :users, :unlock_token
    remove_column :users, :locked_at   
  end
end
