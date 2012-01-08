Given 'I register as "$full_name" with account "$account_name"' do |full_name, account_name|
  first_name, last_name = full_name.split ' '

  visit root_path

  click_link 'Registration'

  fill_in 'E-mail', :with => 'user@example.org'
  fill_in 'Password', :with => '123456'
  fill_in 'Confirm password', :with => '123456'
  fill_in 'Name', :with => first_name
  fill_in 'Last name', :with => last_name
  fill_in 'Account name', :with => account_name

  click_button 'Register'
end

Given 'a user "$email" with password "$password"' do |email, password|
  create :user, :email => email, :password => password, :password_confirmation => password
end

Given 'a user named "$full_name" exists in my account' do |full_name|
  first_name, last_name = full_name.split ' '

  user = create :user, :first_name => first_name, :last_name => last_name
  create :account_user, :user => user, :account => @current_user.accounts.first
end

When /I (?:|try to )login as "([^"]*)" with password "([^"]*)"/ do |email, password|
  visit root_path

  fill_in 'E-mail', :with => email
  fill_in 'Password', :with => password

  click_button 'Login'
end

Then 'there should be a user "$full_name" owning the account "$account_name"' do |full_name, account_name|
  first_name, last_name = full_name.split ' '

  user = User.find_by_first_name_and_last_name! first_name, last_name
  account = Account.find_by_name! account_name

  user.owned_accounts.should include(account)
end

Then 'I should be logged in' do
  page.should have_content 'Signed in successfully'
end

Then 'I should not be logged in' do
  page.should have_content 'Invalid email/password or account.'
end