require 'spec_helper'

describe Accounts::UsersController do
  sign_up_with_account_member

  describe "with admin user" do
    let(:member) { mock_model(User, :account => account) }

    before do
      current_member.stub :admin? => true

      AccountMember.stub :find => member
    end

    describe "GET index" do
      it "renders index action" do
        get :index, :account_id => '1'

        controller.should render_template 'index'
      end
    end

    describe "GET show" do
      it "assigns account member as @user" do
        AccountMember.should_receive(:find).with(account, '2').and_return member

        get :show, :account_id => '1', :id => '2'

        controller.should assign_to(:member).with(member)
      end
    end

    describe "DELETE destroy" do
      before { member.stub :remove }

      it "removes account member if possible" do
        member.stub :removable? => true
        member.should_receive(:remove).and_return true

        delete :destroy, :account_id => '1', :id => '2'
      end

      it "redirects to account members with flash message if member is removed" do
        member.stub :removable? => true

        delete :destroy, :account_id => '1', :id => '2'

        controller.should redirect_to account_users_path(member.account)
        controller.should set_the_flash
      end

      it "redirects to account member page with flash message if member is not removable" do
        member.stub :removable? => false

        delete :destroy, :account_id => '1', :id => '2'

        controller.should redirect_to account_user_path(member.account, member)
        controller.should set_the_flash
      end
    end

    describe "PUT set_admin" do
      before { member.stub :set_admin_status_to => true }

      it "changes the admin status of the member" do
        member.should_receive(:set_admin_status_to).with 'true'

        put :set_admin, :account_id => '1', :id => '2', :admin => 'true'
      end

      it "can not chage admin status of the current user" do
        AccountMember.stub :find => current_member

        member.should_not_receive(:set_admin_status_to).with 'true'

        put :set_admin, :account_id => '1', :id => '2', :admin => 'true'
      end

      it "redirects to the member account page" do
        put :set_admin, :account_id => '1', :id => '2', :admin => 'true'

        controller.should redirect_to account_user_path(member.account, member)
      end
    end

    describe "PUT set_projects" do
      before { member.stub :set_projects }

      it "changes projects of a member" do
        member.should_receive(:set_projects).with ['1', '2', '3']

        put :set_projects, :account_id => '1', :id => '2', :user => {:project_ids => ['1', '2', '3']}
      end

      it "redirects to the member account page" do
        put :set_projects, :account_id => '1', :id => '2', :user => {:project_ids => ['1', '2', '3']}

        controller.should redirect_to account_user_path(member.account, member)
      end
    end
  end

  describe "with not-admin user" do
    before do
      current_member.stub :admin? => false

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
