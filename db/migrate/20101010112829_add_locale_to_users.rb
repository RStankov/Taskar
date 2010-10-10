class AddLocaleToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :locale, :string, :limit => "2"
  end

  def self.down
    remove_column :users, :locale
  end
end
