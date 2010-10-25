class RemoveDomainFromAccounts < ActiveRecord::Migration
  def self.up
    remove_column :accounts, :domain
  end

  def self.down
    add_column :accounts, :domain, :string
    add_index :accounts, :domain
  end
end
