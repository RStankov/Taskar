# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

user = User.create(
  :email                  => 'admin@taskar.com', 
  :first_name             => 'Admin', 
  :last_name              => 'Adminov', 
  :password               => '123456', 
  :password_confirmation  => '123456'
)

unless user.new_record?
  p "User '#{user.email}' with password '#{user.password}' created succesfully"
else
  p "User failed to be created: #{user.errors.full_messages}" 
end