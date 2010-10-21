require 'spec_helper'

describe Accounts::UsersController do
  before { sign_up_and_mock_account }

  describe "with admin user" do
    before do
      mock_account.should_receive(:admin?).with(@current_user).and_return true
      mock_account.stub(:users).and_return @users = [mock_user]
    end

    describe "on member action" do
      before do
        @users.should_receive(:find).with("2").and_return mock_user
      end

      describe "GET show" do
        before do
          get :show, :account_id => "1", :id => "2"
        end

        it { should assign_to(:user).with(mock_user) }
        it { should render_template("show") }
      end

      describe "DELETE destroy" do
        before do
          mock_user.should_receive(:destroy)

          delete :destroy, :account_id => "1", :id => "2"
        end

        it { should redirect_to(account_users_url(mock_account)) }
      end

      describe "PUT set_admin" do
        it "should set user admin field to param[:value]" do
          mock_account.should_receive(:set_admin_status).with(mock_user, true)

          put :set_admin, :account_id => "1", :id => "2", :admin => true
        end

        it "should not allow the current user to change his admin status" do
          mock_user.should_receive(:==).with(@current_user).and_return true
          mock_user.stub(:admin?).and_return(true)

          mock_account.should_not_receive(:set_admin_status)

          put :set_admin, :account_id => "1", :id => "2", :admin => true
        end

        it "should redirect to user page" do
          mock_account.should_receive(:set_admin_status)

          put :set_admin, :account_id => "1", :id => "2"

          should redirect_to(account_user_url(mock_account, mock_user))
        end
      end

    end

    describe "GET index" do
      it "shows all users" do
        get :index, :account_id => "1"

        should assign_to(:users).with(@users)
        should render_template("index")
      end
    end
  end

  describe "with not-admin user" do
    before do
      mock_account.should_receive(:admin?).with(@current_user).and_return false

      ensure_deny_access_is_called
    end

    {
      :index      => 'get(:index, :account_id => "1")',
      :show       => 'get(:show, :account_id => "1", :id => "1")',
      :destroy    => 'delete(:destroy, :account_id => "1", :id => "1")',
      :set_admin  => 'put(:set_admin, :account_id => "1", :id => "1")'
    }.each do |(action, code)|
      it "should not allow #{action}, and redirect_to root_url" do
        eval code
      end
    end
  end
end
