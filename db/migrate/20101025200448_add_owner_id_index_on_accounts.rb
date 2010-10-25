class AddOwnerIdIndexOnAccounts < ActiveRecord::Migration
  def self.up
    add_index :accounts, :owner_id
  end

  def self.down
    remove_index :accounts, :owner_id
  end
end
