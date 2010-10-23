require 'spec_helper'

describe Sign::InvitationsController do
  describe "GET 'show'" do
    it "should show invitation by token" do
      Invitation.should_receive(:find_by_token).with("token_value").and_return mock_invitation

      get "show", :id => "token_value"

      should assign_to(:invitation).with(mock_invitation)
      should render_template("show")
    end

    it "should render invalid token if record is not found" do
      Invitation.should_receive(:find_by_token).with("token_value").and_return nil

      get "show", :id => "token_value"

      should render_template("not_found")
    end
  end

  describe "GET 'update'" do
    it "should be successful" do
      Invitation.should_receive(:find_by_token).with("token_value").and_return mock_invitation

      get 'update', :id => "token_value"

      response.should be_success
    end
  end

  describe "GET 'destroy'" do
    it "should be successful" do
      Invitation.should_receive(:find_by_token).with("token_value").and_return mock_invitation

      get 'destroy', :id => "token_value"

      response.should be_success
    end
  end

end
