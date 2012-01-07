Given 'I an registered user with email "$email"' do |email|
  create :user, :email => email
end

Given 'I have forgotten my password' do
  # just express the reason for the password reset
end

When 'I try to reset the password of "$email"' do |email|
  visit root_path

  click_link 'Forgotten password?'

  fill_in 'E-mail', :with => email

  click_button 'Send'
end

When 'I reset my password of "$email" email with "$password"' do |email, password|
  step %(I try to reset the password of "#{email}")

  open_email(email)

  visit_in_email('Change my password')

  fill_in 'Password', :with => password
  fill_in 'Confirm password', :with => password

  click_button 'Change password'
end

When 'I try to reset password with wrong token' do
  visit edit_user_password_path

  fill_in 'Password', :with => '123456'
  fill_in 'Confirm password', :with => '123456'

  click_button 'Change password'
end

Then 'I should be signed in' do
  page.should have_content 'You are now signed in.'
end

Then 'I should be able to login with "$email" and password "$password"' do |email, password|
  visit destroy_user_session_path

  step %(I login as "#{email}" with password "#{password}")
end