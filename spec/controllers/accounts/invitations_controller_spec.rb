require 'spec_helper'

describe Accounts::InvitationsController do
  before { sign_up_and_mock_account }

  describe "with admin user" do
    before do
      mock_account.should_receive(:admin?).with(@current_user).and_return true
    end

    describe "GET 'new'" do
      it "should be successful" do
        get "new", :account_id => "1", :id => "2"
        response.should be_success
      end
    end

    describe "GET 'create'" do
      it "should be successful" do
        post "create", :account_id => "1", :id => "2"
        response.should be_success
      end
    end

    describe "GET 'update'" do
      it "should be successful" do
        get "update", :account_id => "1", :id => "2"
        response.should be_success
      end
    end

    describe "GET 'destroy'" do
      it "should be successful" do
        get "destroy", :account_id => "1", :id => "2"
        response.should be_success
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
