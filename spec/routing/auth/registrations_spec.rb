require 'spec_helper'

describe Auth::RegistrationsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "sign/up" }.should route_to(:controller => "auth/registrations", :action => "new")
    end

    it "recognizes and generates #index" do
      { :get => "sign/edit" }.should route_to(:controller => "auth/registrations", :action => "edit")
    end

    it "recognizes and generates #create" do
      { :post => "sign" }.should route_to(:controller => "auth/registrations", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "sign" }.should route_to(:controller => "auth/registrations", :action => "update")
    end

    it "recognizes and generates #destroy" do
      { :delete => "sign" }.should route_to(:controller => "auth/registrations", :action => "destroy")
    end
  end
end