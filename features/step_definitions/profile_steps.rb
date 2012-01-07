When 'I change my name to "$full_name"' do |full_name|
  first_name, last_name = full_name.split ' '

  click_link 'Profile'

  fill_in 'Name', :with => first_name
  fill_in 'Last name', :with => last_name

  click_button 'Save'

  page.should have_content 'You updated your account successfully.'
end

When 'I change my password to "$password"' do |password|
  click_link 'Profile'

  fill_in 'Password', :with => password
  fill_in 'Confirm password', :with => password
  fill_in 'Current password', :with => @current_user.password

  click_button 'Save'

  page.should have_content 'You updated your account successfully.'
end

Then 'my name should be "$full_name"' do |full_name|
  first_name, last_name = full_name.split ' '

  @current_user.reload

  @current_user.first_name.should eq first_name
  @current_user.last_name.should eq last_name
end

Then 'my password should be "$password"' do |password|
  @current_user.reload
  @current_user.should be_valid_password password
end