Given 'I am logged in as an account owner' do
  user = create :user
  account = create :account, :owner => user
  account_user = create :account_user, :user => user, :account => account

  backdoor_login user
end

Given 'I am logged in' do
  backdoor_login create(:user)
end

Given 'I am logged in project member' do
  backdoor_login create(:project_user).user
end
