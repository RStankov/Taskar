module ControllerMacros
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
  end
  
  def sign_with_user_outside_the_project
    @current_user = Factory(:user)
    sign_in @current_user
    mock_project.should_receive(:involves?).with(@current_user).and_return(false)
    
    ensure_deny_access_is_called
  end
end