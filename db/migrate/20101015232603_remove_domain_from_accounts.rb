class RemoveDomainFromAccounts < ActiveRecord::Migration
  def self.up
    remove_index :accounts, :domain

    remove_column :accounts, :domains
    remove_column :accounts, :domain
  end

  def self.down
    add_column :accounts, :domains, :string
    add_column :accounts, :domain, :string

    add_index :accounts, :domain
  end
end
