require 'spec_helper'

describe Accounts::InvitationsController do
  subject { controller }

  before do
    sign_in @current_user = Factory(:user)
    controller.stub(:current_user).and_return @current_user
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
