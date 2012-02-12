require 'spec_helper'

describe Accounts::UsersController do
  let(:account)      { mock_model(Account) }
  let(:current_user) { mock_model(User) }
  let(:user)         { mock_model(User) }

  before do
    controller.stub :authenticate_user!
    controller.stub :current_user => current_user

    current_user.stub :find_account => account

    account.stub_chain :users, :find => user
  end

  describe "with admin user" do
    before do
      account.should_receive(:admin?).with(current_user).and_return true
    end

    describe "GET index" do
      it "renders index action" do
        get :index, :account_id => '1'

        controller.should render_template 'index'
      end
    end

    describe "GET show" do
      it "assigns user as @user" do
        controller.should_receive(:find_user).and_return user

        get :show, :account_id => '1', :id => '2'

        controller.should assign_to(:user).with(user)
      end
    end

    describe "DELETE destroy" do
      before { account.stub :remove_user => false }

      it "removes an user from account" do
        account.should_receive(:remove_user).with(user).and_return true

        delete :destroy, :account_id => '1', :id => '2'
      end

      it "redirects to account users with flash message" do
        delete :destroy, :account_id => '1', :id => '2'

        controller.should redirect_to account_users_path(account)
        controller.should set_the_flash
      end
    end

    describe "PUT set_admin" do
      before { account.stub :set_admin_status => true }

      it "changes the admin status of the user" do
        account.should_receive(:set_admin_status).with(user, 'true')

        put :set_admin, :account_id => '1', :id => '2', :admin => 'true'
      end

      it "can not chage admin status of the current user" do
        controller.stub :find_user => current_user

        account.should_not_receive(:set_admin_status).with(user, 'true')

        put :set_admin, :account_id => '1', :id => '2', :admin => 'true'
      end

      it "redirects to the user account page" do
        put :set_admin, :account_id => '1', :id => '2', :admin => 'true'

        controller.should redirect_to account_user_path(account, user)
      end
    end

    describe "PUT set_user_projects" do
      before { account.stub :set_user_projects => true }

      it "changes projects of the user" do
        account.should_receive(:set_user_projects).with user, ['1', '2', '3']

        put :set_projects, :account_id => '1', :id => '2', :user => {:project_ids => ['1', '2', '3']}
      end

      it "redirects to the user account page" do
        put :set_projects, :account_id => '1', :id => '2', :user => {:project_ids => ['1', '2', '3']}

        controller.should redirect_to account_user_path(account, user)
      end
    end
  end

  describe "with not-admin user" do
    before do
      account.stub(:admin?).with(current_user).and_return false

      ensure_deny_access_is_called
    end

    {
      :index        => 'get(:index, :account_id => "1")',
      :show         => 'get(:show, :account_id => "1", :id => "1")',
      :destroy      => 'delete(:destroy, :account_id => "1", :id => "1")',
      :set_admin    => 'put(:set_admin, :account_id => "1", :id => "1")',
      :set_projects => 'put(:set_projects, :account_id => "1", :id => "1")'
    }.each do |(action, code)|
      it "does not allow #{action}, and redirect to root url" do
        eval code
      end
    end
  end
end
