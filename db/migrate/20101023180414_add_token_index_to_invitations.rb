class AddTokenIndexToInvitations < ActiveRecord::Migration
  def self.up
    add_index :invitations, :token
  end

  def self.down
    remove_index :invitations, :token
  end
end
