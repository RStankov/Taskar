require 'spec_helper'

describe Accounts::ProjectsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "accounts/1/projects" }.should route_to(:controller => "accounts/projects", :action => "index", :account_id => "1")
    end

    it "recognizes and generates #new" do
      { :get => "accounts/1/projects/new" }.should route_to(:controller => "accounts/projects", :action => "new", :account_id => "1")
    end

    it "recognizes and generates #show" do
      { :get => "accounts/1/projects/1" }.should route_to(:controller => "accounts/projects", :action => "show", :id => "1", :account_id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "accounts/1/projects/1/edit" }.should route_to(:controller => "accounts/projects", :action => "edit", :id => "1", :account_id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "accounts/1/projects" }.should route_to(:controller => "accounts/projects", :action => "create", :account_id => "1")
    end

    it "recognizes and generates #update" do
      { :put => "accounts/1/projects/1" }.should route_to(:controller => "accounts/projects", :action => "update", :id => "1", :account_id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "accounts/1/projects/1" }.should route_to(:controller => "accounts/projects", :action => "destroy", :id => "1", :account_id => "1")
    end

    it "recognizes and generates #complete" do
      { :put => "accounts/1/projects/1/complete" }.should route_to(:controller => "accounts/projects", :action => "complete", :id => "1", :account_id => "1")
    end
  end
end
