require 'spec_helper'

describe UsersController do
  subject { controller }

  before do
    sign_in @current_user = Factory(:user)

    controller.stub(:current_user).and_return @current_user

    Account.stub(:find).with("1").and_return mock_account
  end

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

      describe "GET edit" do
        before do
          get :edit, :account_id => "1", :id => "2"
        end

        it { should assign_to(:user).with(mock_user) }
        it { should render_template("edit") }
      end

      describe "PUT update" do
         it "should render edit template when user is invalid" do
          mock_user.should_receive(:update_attributes).with({"these" => "params"}).and_return(false)

          put :update, :account_id => "1", :id => "2", :user => {:these => "params"}

          should assign_to(:user).with(mock_user)
          should render_template("edit")
        end

        it "should redirect to users page, when user is valid" do
          mock_user.should_receive(:update_attributes).with({"these" => "params"}).and_return(true)

          put :update, :account_id => "1", :id => "2", :user => {:these => "params"}

          should assign_to(:user).with(mock_user)
          should redirect_to(account_user_url(mock_account, mock_user))
        end
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

    describe "on collection action" do
      describe "GET index" do
        before do
          get :index, :account_id => "1"
        end

        it { should assign_to(:users).with(@users) }
        it { should render_template("index") }
      end

      describe "GET new" do
        before do
          @users.should_receive(:build).and_return User.new

          get :new, :account_id => "1"
        end

        it { assigns[:user].should be_new_record }
        it { should render_template("new") }
      end

      describe "POST create" do
        def user_params
          {:these => "params"}
        end

        def post_create(params = {})
          post :create, {:user => user_params, :account_id => "1"}.merge(params)
        end

        before do
          User.should_receive(:new).with(user_params.stringify_keys).and_return mock_user
        end

        it "should render new template when user is invalid" do
          mock_user.should_receive(:save).and_return(false)

          post_create

          should assign_to(:user).with(mock_user)
          should render_template("new")
        end

        it "should redirect to users page, when user is valid" do
          AccountUser.should_receive(:create).with(:user => mock_user, :account => mock_account)

          mock_user.should_receive(:save).and_return(true)

          post_create

          should assign_to(:user).with(mock_user)
          should redirect_to(account_user_url(mock_account, mock_user))
        end
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
      :new        => 'get(:new, :account_id => "1")',
      :create     => 'post(:create, :account_id => "1")',
      :edit       => 'get(:edit, :account_id => "1", :id => "1")',
      :update     => 'put(:update, :account_id => "1", :id => "1")',
      :destroy    => 'delete(:destroy, :account_id => "1", :id => "1")',
      :set_admin  => 'put(:set_admin, :account_id => "1", :id => "1")'
    }.each do |(action, code)|
      it "should not allow #{action}, and redirect_to root_url" do
        eval code
      end
    end
  end
end
