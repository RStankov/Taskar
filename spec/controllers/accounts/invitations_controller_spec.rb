require 'spec_helper'

describe Accounts::InvitationsController do
  before do
    sign_up_and_mock_account

    mock_account.stub(:invitations).and_return @inviations = []
  end

  describe "with admin user" do
    before do
      mock_account.should_receive(:admin?).with(@current_user).and_return true
    end

    describe "GET 'new'" do
      it "should display new invitation form" do
        Invitation.should_receive(:new).and_return mock_invitation

        get "new", :account_id => "1"

        should assign_to(:invitation).with(mock_invitation)
        should render_template("new")
      end
    end

    describe "POST 'create'" do
      before do
        @inviations.should_receive(:build).with("these" => "params").and_return mock_invitation
      end

      it "should create new invitation, and redirect to users, on valid data" do
        mock_invitation.should_receive(:save).and_return true

        post "create", :account_id => "1", :invitation => {"these" => "params"}

        should assign_to(:invitation).with(mock_invitation)
        should redirect_to([mock_account, :users])
      end

      it "should render 'new' form, on invaild data" do
        mock_invitation.should_receive(:save).and_return false

        post "create", :account_id => "1", :invitation => {"these" => "params"}

        should assign_to(:invitation).with(mock_invitation)
        should render_template("new")
      end

      it "should send the invitation" do
        mock_invitation.stub :save => true
        mock_invitation.should_receive(:send_invite)

        post "create", :account_id => "1", :invitation => {"these" => "params"}
      end
    end

    describe "PUT 'update'" do
      it "should be successful" do
        @inviations.should_receive(:find).with("2").and_return mock_invitation

        mock_invitation.should_receive(:send_invite)

        get "update", :account_id => "1", :id => "2"

        should redirect_to [mock_account, :users]
      end
    end

    describe "DELETE 'destroy'" do
      it "should be destroy invitation and redirect" do
        @inviations.should_receive(:find).with("2").and_return mock_invitation

        mock_invitation.should_receive(:destroy)

        get "destroy", :account_id => "1", :id => "2"

        should redirect_to([mock_account, :users])
      end
    end
  end

  describe "with not-admin user" do
    before do
      mock_account.should_receive(:admin?).with(@current_user).and_return false

      ensure_deny_access_is_called
    end

    {
      :new        => 'get(:new, :account_id => "1")',
      :create     => 'post(:create, :account_id => "1")',
      :update     => 'put(:update, :account_id => "1", :id => "1")',
      :destroy    => 'delete(:destroy, :account_id => "1", :id => "1")'
    }.each do |(action, code)|
      it "should not allow #{action}, and redirect_to root_url" do
        eval code
      end
    end
  end
end
