module ControllerMacros
  module ClassMethods
    def sign_up_with_account_member
      let(:account)        { mock_model(Account) }
      let(:current_member) { mock_model(User)    }

      before do
        user = double
        user.stub :find_account => account

        controller.stub :authenticate_user!
        controller.stub :current_user => user

        AccountMember.stub :new => current_member

        current_member.stub :account => account
      end
    end
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