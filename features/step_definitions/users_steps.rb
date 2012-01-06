Given 'I logged in as an account owner' do
  user = create :user
  account = create :account, :owner => user
  account_user = create :account_user, :user => user, :account => account

  visit "/backdoor-login?email=#{CGI.escape(user.email)}"

  @current_user = user
end
