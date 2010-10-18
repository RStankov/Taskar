require 'spec_helper'

describe Accounts::InvitationsController do
  describe "routing" do
    it "recognizes and generates #new" do
      { :get => "accounts/1/invitations/new" }.should route_to(:controller => "accounts/invitations", :action => "new", :account_id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "accounts/1/invitations" }.should route_to(:controller => "accounts/invitations", :action => "create", :account_id => "1")
    end

    it "recognizes and generates #update" do
      { :put => "accounts/1/invitations/2" }.should route_to(:controller => "accounts/invitations", :action => "update", :id => "2", :account_id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "accounts/1/invitations/2" }.should route_to(:controller => "accounts/invitations", :action => "destroy", :id => "2", :account_id => "1")
    end
  end
end
