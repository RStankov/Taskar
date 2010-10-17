class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.integer :account_id
      t.string :email
      t.string :token
      t.datetime :send_at
      t.string :first_name
      t.string :last_name
      t.string :message
      t.boolean :rejected
      t.timestamps
    end

    add_index :invitations, :email
    add_index :invitations, :account_id
  end

  def self.down
    drop_table :invitations
  end
end
