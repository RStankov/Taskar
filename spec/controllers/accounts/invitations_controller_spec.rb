require 'spec_helper'

describe Accounts::InvitationsController do
  sign_up_with_account_member

  context "with admin user" do
    let(:invitation) { mock_model(Invitation) }

    before do
      current_member.stub :admin? => true

      account.stub :invitations => []
    end

    describe "GET 'new'" do
      it "assings new invitation" do
        Invitation.should_receive(:new).and_return invitation

        get :new, :account_id => '1'

        controller.should assign_to(:invitation).with(invitation)
      end
    end

    describe "POST 'create'" do
      before do
        account.invitations.stub :build => invitation

        invitation.stub :send_invite
        invitation.stub :save => true
      end

      it "assigns the new invitaion" do
        account.invitations.should_receive(:build).with('these' => 'params').and_return invitation

        post :create, :account_id => '1', :invitation => {'these' => 'params'}

        controller.should assign_to(:invitation).with(invitation)
      end

      it "creates new invitation" do
        invitation.should_receive(:save).and_return true

        post :create, :account_id => '1'
      end

      it "send the invitation, on succesfull creation" do
        invitation.stub :save => true
        invitation.should_receive :send_invite

        post :create, :account_id => '1'
      end

      it 'redirects to account users with flash message, on succesfull creation' do
        invitation.stub :save => true

        post :create, :account_id => '1'

        controller.should redirect_to account_members_path(account)
        controller.should set_the_flash

      end

      it "renders new action, on unsuccesfull creation" do
        invitation.stub :save => false

        post :create, :account_id => '1'

        controller.should render_template 'new'
      end
    end

    describe "PUT 'update'" do
      before do
        account.invitations.stub :find => invitation
        invitation.stub :send_invite
      end

      it "sends an other invitation" do
        invitation.should_receive :send_invite

        put :update, :account_id => '1', :id => '2'
      end

      it "redirects backs to account inviations with flash message" do
        put :update, :account_id => '1', :id => '2'

        controller.should redirect_to account_invitations_path(account)
        controller.should set_the_flash
      end
    end

    describe "DELETE 'destroy'" do
      before do
        account.invitations.stub :find => invitation
        invitation.stub :destroy
      end

      it "sends an other invitation" do
        invitation.should_receive :destroy

        put :destroy, :account_id => '1', :id => '2'
      end

      it "redirects backs to account inviations" do
        put :destroy, :account_id => '1', :id => '2'

        controller.should redirect_to account_invitations_path(account)
      end
    end
  end

  context "with not-admin user" do
    before do
      current_member.stub :admin? => false

      ensure_deny_access_is_called
    end

    {
      :new        => 'get(:new, :account_id => "1")',
      :create     => 'post(:create, :account_id => "1")',
      :update     => 'put(:update, :account_id => "1", :id => "1")',
      :destroy    => 'delete(:destroy, :account_id => "1", :id => "1")'
    }.each do |(action, code)|
      it "should not allow #{action}, and redirect to root url" do
        eval code
      end
    end
  end
end
