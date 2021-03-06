Given '"$user_name" is admin' do |user_name|
  user = find_user user_name
  user.account_users.first.update_attributes! :admin => true
end

When 'I rename my account name to "$account_name"' do |account_name|
  visit account_path(current_account)

  click_on "Edit #{current_account.name}"

  fill_in 'Account name', :with => account_name

  click_on 'Update'
end

When 'I toggle the admin access of "$user_name"' do |user_name|
  goto_user_account_page user_name

  click_on 'Administrator'
end

When 'I delete "$user_name" from my account' do |user_name|
  goto_user_account_page user_name

  click_on 'Remove'
end

Then '"$user_name" should not be in my account' do |user_name|
  user = find_user user_name

  account = current_account
  account.reload
  account.users.should_not include(user)
end

Then '"$user_name" user should still exist' do |user_name|
  find_user user_name
end

Then 'I should be owner of the "$account_name" account' do |account_name|
  current_account.reload.name.should eq account_name
end

Then '"$user_name" should be admin in my account' do |user_name|
  user = find_user user_name
  user.account_users.first.should be_admin
end

Then '"$user_name" should not be admin in my account' do |user_name|
  user = find_user user_name
  user.account_users.first.should_not be_admin
end

Then 'I should not be able to delete "$user_name" from my account' do |user_name|
  goto_user_account_page user_name

  page.should_not have_content 'Remove'
end

