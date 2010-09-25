require 'spec_helper'

describe UsersController do
  subject { controller }

  describe "with admin user" do
    before do
      sign_in @current_user = Factory(:user, :admin => true)

      controller.stub(:current_user).and_return @current_user
      @current_user.should_receive(:account).and_return mock_account
      mock_account.stub(:users).and_return @users = [mock_user]
    end

    describe "on member action" do
      before do
        @users.should_receive(:find).with("15").and_return mock_user
      end

      describe "GET show" do
        before do
          get :show, :id => "15"
        end

        it { should assign_to(:user).with(mock_user) }
        it { should render_template("show") }
      end

      describe "GET edit" do
        before do
          get :edit, :id => "15"
        end

        it { should assign_to(:user).with(mock_user) }
        it { should render_template("edit") }
      end

      describe "PUT update" do
        def user_params
          {:these => 'params'}
        end

        def put_update(params = {})
          put :update, {:id => "15", :user => user_params}.merge(params)
        end

        it "should render edit template when user is invalid" do
          mock_user.should_receive(:update_attributes).with(user_params.stringify_keys).and_return(false)

          put_update

          should assign_to(:user).with(mock_user)
          should render_template("edit")
        end

        it "should redirect to users page, when user is valid" do
          mock_user.should_receive(:update_attributes).with(user_params.stringify_keys).and_return(true)

          put_update

          should assign_to(:user).with(mock_user)
          should redirect_to(user_url(mock_user))
        end
      end

      describe "DELETE destroy" do
        before do
          mock_user.should_receive(:destroy)

          delete :destroy, :id => "15"
        end

        it { should redirect_to(users_url) }
      end

      describe "PUT set_admin" do
        it "should set user admin field to param[:value]" do
          mock_user.should_receive(:admin=).with(true)
          mock_user.should_receive(:save)

          put :set_admin, :id => "15", :admin => true
        end

        it "should not allow the current user to change his admin status" do
          mock_user.should_receive(:==).with(@current_user).and_return true
          mock_user.stub(:admin?).and_return(true)

          mock_user.should_not_receive(:admin=)
          mock_user.should_not_receive(:save)

          put :set_admin, :id => "15", :admin => true
        end

        it "should redirect to user page" do
          mock_user.stub!(:admin=)
          mock_user.stub!(:save)

          put :set_admin, :id => "15"

          should redirect_to(user_url(mock_user))
        end
      end

    end

    describe "on collection action" do
      describe "GET index" do
        before do
          get :index
        end

        it { should assign_to(:users).with(@users) }
        it { should render_template("index") }
      end

      describe "GET new" do
        before do
          @users.should_receive(:build).and_return User.new

          get :new
        end

        it { assigns[:user].should be_new_record }
        it { should render_template("new") }
      end

      describe "POST create" do
        def user_params
          {:these => "params"}
        end

        def post_create(params = {})
          post :create, {:user => user_params}.merge(params)
        end

        before do
          @users.should_receive(:build).with(user_params.stringify_keys).and_return mock_user
        end

        it "should render new template when user is invalid" do
          mock_user.should_receive(:save).and_return(false)

          post_create

          should assign_to(:user).with(mock_user)
          should render_template("new")
        end

        it "should redirect to users page, when user is valid" do
          mock_user.should_receive(:save).and_return(true)

          post_create

          should assign_to(:user).with(mock_user)
          should redirect_to(user_url(mock_user))
        end
      end
    end
  end

  describe "with normal user" do
    before do
      sign_in Factory(:user)

      ensure_deny_access_is_called
    end

    {
      :index      => 'get(:index)',
      :show       => 'get(:show, :id => "1")',
      :new        => 'get(:new)',
      :create     => 'post(:create)',
      :edit       => 'get(:edit, :id => "1")',
      :update     => 'put(:update, :id => "1")',
      :destroy    => 'delete(:destroy, :id => "1")',
      :set_admin  => 'put(:set_admin, :id => "1")'
    }.each do |(action, code)|
      it "should not allow #{action}, and redirect_to root_url" do
        eval code
      end
    end
  end
end
