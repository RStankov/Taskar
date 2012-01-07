module CucumberHelpers
  def backdoor_login(user)
    visit "/backdoor-login?email=#{CGI.escape(user.email)}"

    @current_user = user
  end
end