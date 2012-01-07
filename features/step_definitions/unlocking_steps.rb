Given 'the user with email "$email" is locked' do |email|
  user = User.find_by_email! email
  user.lock_access!
end

When 'I request an unlock email for "$email"' do |email|
  visit root_path

  click_link 'Unlock account'

  fill_in 'E-mail', :with => email

  click_button 'Unlock'
end

When 'I unlock my account from the link send to "$email"' do |email|
  open_email(email)

  visit_in_email('Unlock my account')
end