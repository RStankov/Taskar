require 'spec_helper'

describe Accounts::AccountsController do
  sign_up_with_account_member

  describe "with account owner" do
    before { current_member.stub :admin? => true, :owner? => true }

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
        controller.should redirect_to account_path(account)
      end

      it "renders edit action if update wasn't successfull" do
        account.stub :update_attributes => false

        put :update, :id => '1', :account => { :these => 'params' }

        controller.should render_template 'edit'
      end
    end
  end

  describe "with admin user" do
    before { current_member.stub :admin? => true, :owner? => false }

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
      current_member.stub :admin? => false

      ensure_deny_access_is_called
    end

    {
      :show       => 'get(:show, :id => "1")',
      :edit       => 'get(:edit, :id => "1")',
      :update     => 'put(:update, :id => "1")',
    }.each do |(action, code)|
      it "does not allow #{action}, and redirect to root url" do
        eval code
      end
    end
  end

end
