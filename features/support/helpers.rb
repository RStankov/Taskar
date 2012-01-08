module CucumberHelpers
  def backdoor_login(user)
    visit "/backdoor-login?email=#{CGI.escape(user.email)}"

    @current_user = user
  end

  def find_user(full_name)
    User.find_by_first_name_and_last_name! *(full_name.split ' ', 2)
  end

  def current_account
    @current_user.accounts.first
  end
end