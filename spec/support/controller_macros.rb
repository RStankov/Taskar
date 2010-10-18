module ControllerMacros
  def sign_up_and_mock_account
    sign_in @current_user = Factory(:user)
    controller.stub(:current_user).and_return @current_user

    @current_user.stub(:accounts).and_return accounts = []
    accounts.stub(:find).with("1").and_return mock_account
  end

  def ensure_deny_access_is_called
    def controller.deny_access
      _deny_access_called_
      redirect_to root_path
    end

    controller.should_receive(:_deny_access_called_)
  end

  def sign_with_project_user
    @current_user = Factory(:user)
    sign_in @current_user

    mock_project.should_receive(:involves?).with(@current_user).and_return(true)
    controller.stub!(:current_user).and_return(@current_user)
  end

  def sign_with_user_outside_the_project
    @current_user = Factory(:user)
    sign_in @current_user

    mock_project.should_receive(:involves?).with(@current_user).and_return(false)
    controller.stub!(:current_user).and_return(@current_user)

    ensure_deny_access_is_called
  end
end