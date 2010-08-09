class AddLastSeenEventAtToProjectUsers < ActiveRecord::Migration
  def self.up
    add_column :project_users, :last_seen_event_at, :datetime
  end

  def self.down
    remove_column :project_users, :last_seen_event_at
  end
end
