require 'spec_helper'

describe Sign::InvitationsController do
  before do
    Invitation.stub(:find_by_token).with("token_value").and_return mock_invitation(:user => mock_user)
  end

  describe "GET 'show'" do
    it "should show invitation by token" do
      get "show", :id => "token_value"

      should assign_to(:invitation).with(mock_invitation)
      should render_template("show")
    end

    it "should render invalid token if record is not found" do
      Invitation.stub(:find_by_token).with("token_value").and_return nil

      get "show", :id => "token_value"

      should render_template("not_found")
    end
  end

  describe "PUT 'update'" do
    it "should sign_in @invitation.user and redirect to root if #process_user is true" do
      controller.should_receive(:process_user).with("these" => "params").and_return true
      controller.should_receive(:sign_in).with(mock_user)

      put :update, :id => "token_value", :user => {"these" => "params"}

      should set_the_flash.to(I18n.t("devise.invitations.complete"))
      should redirect_to(:root)
    end

    it "should sign_in @invitation.user and redirect to root if #process_user is true" do
      controller.should_receive(:process_user).with("these" => "params").and_return false

      put :update, :id => "token_value", :user => {"these" => "params"}

      should assign_to(:invitation).with(mock_invitation)
      should render_template("show")
    end
  end

  describe "GET 'destroy'" do
    it "should be successful" do
      Invitation.should_receive(:find_by_token).with("token_value").and_return mock_invitation

      get 'destroy', :id => "token_value"

      response.should be_success
    end
  end

  describe "#process_user" do
    before do
      controller.instance_variable_set "@invitation", mock_invitation
    end

    it "should try to create new user if invitation user is new" do
      mock_user.should_receive(:new_record?).and_return true
      mock_invitation.should_receive(:create_user).with("params").and_return "result from trying to create user"

      controller.send(:process_user, "params").should == "result from trying to create user"
    end

    it "should validate user password if invitation user is existing user" do
      mock_user.should_receive(:new_record?).and_return false
      mock_user.should_receive(:valid_password?).with("password").and_return "result form veryfing user"

      controller.send(:process_user, :password => "password").should == "result form veryfing user"
    end
  end
end
