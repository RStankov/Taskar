class RemoveRejectedFromInvitations < ActiveRecord::Migration
  def self.up
    remove_column :invitations, :rejected
  end

  def self.down
    add_column :invitations, :rejected, :boolean
  end
end
