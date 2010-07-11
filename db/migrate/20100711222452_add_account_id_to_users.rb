class AddAccountIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :account_id, :integer
    
    if User.count > 0 && Account.count > 0
      execute "UPDATE users SET account_id = '#{Account.first.id}'"
    end
  end

  def self.down
    remove_column :users, :account_id
  end
end
