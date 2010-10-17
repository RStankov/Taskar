require 'spec_helper'

describe Accounts::AccountsController do
  before do
    sign_in @current_user = Factory(:user)
    controller.stub(:current_user).and_return @current_user

    @current_user.stub(:accounts).and_return accounts = []
    accounts.stub(:find).with("1").and_return mock_account
  end

  describe "with admin user" do
    before do
      mock_account.should_receive(:admin?).with(@current_user).and_return true
    end

    describe "GET 'show'" do
      before { get "show", :id => "1" }

      it { should assign_to(:account).with(mock_account) }
      it { should render_template("show") }
    end

    describe "GET 'edit'" do
      before { get "edit", :id => "1" }

      it { should assign_to(:account).with(mock_account) }
      it { should render_template("edit") }
    end


    describe "PUT update" do
      before do
        mock_account.should_receive(:instance_variable_set).with("@readonly", false)
      end

      it "should update account if data valid" do
        mock_account.should_receive(:update_attributes).with("these" => "params").and_return true

        put "update", :id => "1", :account => { :these => "params" }

        should assign_to(:account).with(mock_account)
        should set_the_flash
        should redirect_to(account_url(mock_account))
      end

      it "should not update account if data is not valid" do
        mock_account.should_receive(:update_attributes).with("these" => "params").and_return false

        put "update", :id => "1", :account => { :these => "params" }

        should assign_to(:account).with(mock_account)
        should_not set_the_flash
        should render_template("edit")
      end
    end
  end

  describe "with normal user" do
    before do
      mock_account.should_receive(:admin?).with(@current_user).and_return false

      ensure_deny_access_is_called
    end

    {
      :show       => 'get(:show, :id => "1")',
      :edit       => 'get(:edit, :id => "1")',
      :update     => 'put(:update, :id => "1")',
    }.each do |(action, code)|
      it "should not allow #{action}, and redirect_to root_url" do
        eval code
      end
    end
  end

end
