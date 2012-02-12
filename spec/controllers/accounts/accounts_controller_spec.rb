require 'spec_helper'

describe Accounts::AccountsController do
  before { sign_up_and_mock_account }

  let(:account)      { mock_model(Account) }
  let(:current_user) { mock_model(User) }

  before do
    controller.stub :authenticate_user!
    controller.stub :current_user => current_user

    current_user.stub :find_account => account
  end

  describe "with account owner" do
    before do
      account.stub(:admin?).with(current_user).and_return true
      account.stub(:owner?).with(current_user).and_return true
    end

    describe "GET 'edit'" do
      it "assigns the account" do
        get :edit, :id => '1'

        controller.should assign_to(:account).with(account)
      end
    end

    describe "PUT update" do
      it "tries to update the account" do
        account.should_receive(:update_attributes).with('these' => 'params').and_return true

        put :update, :id => '1', :account => { :these => 'params' }
      end

      it "redirects to account show page with flash message on successfull update" do
        account.stub :update_attributes => true

        put :update, :id => '1'

        controller.should set_the_flash
        controller.should redirect_to(account_url(account))
      end

      it "renders edit action if update wasn't successfull" do
        account.stub :update_attributes => false

        put :update, :id => '1', :account => { :these => 'params' }

        controller.should render_template 'edit'
      end
    end
  end

  describe "with admin user" do
    before do
      account.stub(:admin?).with(current_user).and_return true
      account.stub(:owner?).with(current_user).and_return false
    end

    describe "GET 'show'" do
      it "renders show action" do
        get :show, :id => '1'

        should render_template 'show'
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

  describe "with normal user" do
    before do
      account.stub(:admin?).with(current_user).and_return false

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
