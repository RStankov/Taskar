# create the first user for Taskar
if User.count == 0
  user = User.create(
    :email                  => 'admin@taskar.com', 
    :first_name             => 'Admin', 
    :last_name              => 'Adminov', 
    :password               => '123456', 
    :password_confirmation  => '123456',
    :admin                  => true
  )

  unless user.new_record?
    p "User '#{user.email}' with password '#{user.password}' was created succesfully"
  else
    p "User failed to be created: #{user.errors.full_messages}" 
  end
end

# create first project for taskar
if Account.count == 0
  account = Account.new :name => "Taskar"
  account.owner = User.first
  if account.save
    p "Account '#{account.name}' was created succesfully"
  else
    p "Account failed to be created: #{account.errors.full_messages}"
  end
end