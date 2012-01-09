module CucumberHelpers
  def backdoor_login(user)
    visit "/backdoor-login?email=#{CGI.escape(user.email)}"

    @current_user = user
  end

  def find_user(full_name)
    User.find_by_first_name_and_last_name! *(full_name.split ' ', 2)
  end

  def current_account
    @current_account ||= @current_user.accounts.first
  end

  def current_project
    @current_project ||= @current_user.projects.first
  end

  def javascript_enabled?
    Capybara.current_driver == :selenium
  end

  def wait_for_ajax_to_complete
    # wait_until { page.evaluate_script('window.$ && $.active == 0') } if javascript_enabled?
    wait_until { page.evaluate_script('window.Ajax && Ajax.activeRequestCount == 0') } if javascript_enabled?
  end

  def confirm_on_next_action
    page.evaluate_script 'window.confirm = function(msg) { return true; }'
  end
end