Given 'I am "$first_name $last_name" owner of "$account_name" account' do |first_name, last_name, account_name|
  @current_user = Factory(:user, :first_name => first_name, :last_name => last_name, :email => "user@gmail.com", :password => "password", :password_confirmation => "password")
  @account = Factory(:account, :name => account_name, :owner => @current_user)
  @account_user = Factory(:account_user, :user => @current_user, :account => @account)
end

Given 'I am logged in' do
  step "I am on the home page"
  step "I fill in \"E-mail\" with \"#{@current_user.email}\""
  step "I fill in \"Password\" with \"password\""
  step "I press \"Login\""
  step "I should see \"Signed in successfully.\""
end