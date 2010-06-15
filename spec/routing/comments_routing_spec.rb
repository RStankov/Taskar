require 'spec_helper'

describe CommentsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/comments" }.should_not be_routable
    end

    it "recognizes and generates #new" do
      { :get => "/comments/new" }.should_not be_routable
    end

    it "recognizes and generates #show" do
      { :get => "/comments/1" }.should_not be_routable
    end

    it "recognizes and generates #edit" do
      { :get => "/comments/1/edit" }.should route_to(:controller => "comments", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "tasks/1/comments" }.should route_to(:controller => "comments", :action => "create", :task_id => "1") 
    end

    it "recognizes and generates #update" do
      { :put => "/comments/1" }.should route_to(:controller => "comments", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/comments/1" }.should route_to(:controller => "comments", :action => "destroy", :id => "1") 
    end
  end
end
