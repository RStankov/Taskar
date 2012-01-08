Given 'I have invited "$email" to my account' do |email|
  create :invitation, :email => email, :account => current_account
end

When 'I invite "$email" to my account' do |email|
  visit account_path(current_account)

  click_link 'Invite user'

  fill_in 'E-mail', :with => email
  fill_in 'First name', :with => 'Radoslav'
  fill_in 'Last name', :with => 'Stankov'

  click_button 'Send'
end

When 'I resent my invitation' do
  visit account_path(current_account)

  click_link 'Manage users'
  click_link 'Resend invitation'
end

When 'I delete my invitation' do
  visit account_path(current_account)

  click_link 'Manage users'
  click_link 'Delete'
end

When '"$email" accepts my invitation' do |email|
  open_email(email)

  visit_in_email('Accept invitation')

  fill_in 'Password', :with => '123456'
  fill_in 'Confirm password', :with => '123456'

  click_button 'Accept invitation'
end

When '"$email" accepts my invitation confirming with "$password" password' do |email, password|
  open_email(email)

  visit_in_email('Accept invitation')

  fill_in 'enter your password', :with => password

  click_button 'Accept invitation'
end

Then 'the user with "$email" should be in my account' do |email|
  user = User.find_by_email! email

  current_account.users.should include(user)
end

Then 'there should not be an invitation for "$email"' do |email|
  Invitation.find_by_email(email).should_not be_present
end

