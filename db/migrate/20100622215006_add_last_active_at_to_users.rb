class AddLastActiveAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :last_active_at, :datetime
    
    User.update_all(:last_active_at => Time.now)
  end

  def self.down
    remove_column :users, :last_active_at
  end
end
