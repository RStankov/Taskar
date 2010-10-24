require 'spec_helper'

describe Accounts::AccountsController do
  before { sign_up_and_mock_account }

  describe "with admin user" do
    before do
      mock_account.should_receive(:admin?).with(@current_user).and_return true
      mock_account.stub(:owner_id).stub(:owner_id).and_return 0
    end

    describe "GET 'show'" do
      it "should show accounts projects events" do
        mock_account.stub_chain :projects, :active => [mock_project, mock_project]

        get "show", :id => "1"

        should assign_to(:projects).with([mock_project, mock_project])
        should assign_to(:account).with(mock_account)
        should render_template("show")
      end
    end

    {
      :edit       => 'get(:edit, :id => "1")',
      :update     => 'put(:update, :id => "1")'
    }.each do |(action, code)|
      it "should not allow #{action}, and redirect_to root_url" do
        ensure_deny_access_is_called
        eval code
      end
    end
  end

  describe "with account owner" do
    before do
      mock_account.should_receive(:admin?).with(@current_user).and_return true
      mock_account.stub(:owner_id).and_return @current_user.id
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
