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

Given '"$project_name" project exists for "$account_name"' do |project_name, account_name|
  account = Account.find_by_name(account_name) || Factory(:account, :name => account_name)
  @project = Factory(:project, :name => project_name, :account => account)
end

Then 'the project should be completed' do
  @project.reload.should be_completed
end

Then 'the project should not be completed' do
  @project.reload.should_not be_completed
end
