class AddAccountIdToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :account_id, :integer
    
    if Project.count > 0 && Account.count > 0
      execute "UPDATE projects SET account_id = '#{Account.first.id}'"
    end
  end

  def self.down
    remove_column :projects, :account_id
  end
end
