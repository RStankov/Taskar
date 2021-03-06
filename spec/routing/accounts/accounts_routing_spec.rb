require 'spec_helper'

describe Accounts::AccountsController do
  describe "routing" do

    it "recognizes and generates #show" do
      { :get => "/accounts/1" }.should route_to(:controller => "accounts/accounts", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/accounts/1/edit" }.should route_to(:controller => "accounts/accounts", :action => "edit", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :put => "/accounts/1" }.should route_to(:controller => "accounts/accounts", :action => "update", :id => "1")
    end
  end
end