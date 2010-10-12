require 'spec_helper'

describe AccountsController do
  before do
    sign_in @current_user = Factory(:user)
    controller.stub(:current_user).and_return @current_user
  end

  describe "member action" do
    before do
      Account.stub(:find).with("1").and_return mock_account
    end

    describe "GET 'show'" do
      before { get 'show', :id => "1" }

      it { should assign_to(:account).with(mock_account) }
      it { should render_template("show") }
    end

    describe "GET 'edit'" do
      before { get 'edit', :id => "1" }

      it { should assign_to(:account).with(mock_account) }
      it { should render_template("edit") }
    end


    describe "PUT update" do
      it "should update account if data valid" do
        mock_account.should_receive(:update_attributes).with("these" => "params").and_return true

        put 'update', :id => "1", :account => { :these => "params" }

        should assign_to(:account).with(mock_account)
        should set_the_flash
        should redirect_to(account_url(mock_account))
      end

      it "should not update account if data is not valid" do
        mock_account.should_receive(:update_attributes).with("these" => "params").and_return false

        put 'update', :id => "1", :account => { :these => "params" }

        should assign_to(:account).with(mock_account)
        should_not set_the_flash
        should render_template("edit")
      end
    end
  end
end
