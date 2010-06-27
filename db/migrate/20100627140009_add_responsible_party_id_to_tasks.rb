class AddResponsiblePartyIdToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :responsible_party_id, :integer
  end

  def self.down
    remove_column :tasks, :responsible_party_id
  end
end
