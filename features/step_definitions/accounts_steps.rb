When 'I rename my account name to "$account_name"' do |account_name|
  visit account_path(@current_user.accounts.first)

  click_link 'Edit'

  fill_in 'Account name', :with => account_name

  click_button 'Save'
end

Then 'I should be owner of the "$account_name" account' do |account_name|
  @current_user.reload
  @current_user.accounts.first.name.should eq account_name
end
