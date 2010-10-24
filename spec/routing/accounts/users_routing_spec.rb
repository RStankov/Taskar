require 'spec_helper'

describe Accounts::UsersController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "accounts/1/users" }.should route_to(:controller => "accounts/users", :action => "index", :account_id => "1")
    end

    it "recognizes and generates #show" do
      { :get => "accounts/1/users/2" }.should route_to(:controller => "accounts/users", :action => "show", :id => "2", :account_id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "accounts/1/users/2" }.should route_to(:controller => "accounts/users", :action => "destroy", :id => "2", :account_id => "1")
    end

    it "recognizes and generates #set_admin" do
      { :put => "accounts/1/users/2/set_admin" }.should route_to(:controller => "accounts/users", :action => "set_admin", :id => "2", :account_id => "1")
    end

    it "recognizes and generates #set_admin" do
      { :put => "accounts/1/users/2/set_projects" }.should route_to(:controller => "accounts/users", :action => "set_projects", :id => "2", :account_id => "1")
    end
  end
end
