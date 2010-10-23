require 'spec_helper'

describe Sign::InvitationsController do
  describe "routing" do
    it "recognizes and generates #show" do
      { :get => "sign/invitations/some-hash" }.should route_to(:controller => "sign/invitations", :action => "show", :id => "some-hash")
    end

    it "recognizes and generates #update" do
      { :put => "sign/invitations/some-hash" }.should route_to(:controller => "sign/invitations", :action => "update", :id => "some-hash")
    end

    it "recognizes and generates #destroy" do
      { :delete => "sign/invitations/some-hash" }.should route_to(:controller => "sign/invitations", :action => "destroy", :id => "some-hash")
    end
  end
end