Given 'I am "$first_name $last_name" owner of "$account_name" account' do |first_name, last_name, account_name|
  @current_user = Factory(:user, :first_name => first_name, :last_name => last_name, :email => "user@gmail.com", :password => "password", :password_confirmation => "password")
  @account = Factory(:account, :name => account_name, :owner => @current_user)
  @account_user = Factory(:account_user, :user => @current_user, :account => @account)
end

Given 'I am logged in' do
  Given "I am on the home page"
  And "I fill in \"E-mail\" with \"#{@current_user.email}\""
  And "I fill in \"Password\" with \"password\""
  When "I press \"Login\""
  Then "I should see \"Signed in successfully.\""
end