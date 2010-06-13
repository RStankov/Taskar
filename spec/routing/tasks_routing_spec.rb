require 'spec_helper'

describe TasksController do
  describe "routing" do
    it "recognizes and generates #show" do
      { :get => "/tasks/1" }.should route_to(:controller => "tasks", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/tasks/1/edit" }.should route_to(:controller => "tasks", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "projects/1/sections/2/tasks" }.should route_to(:controller => "tasks", :action => "create", :project_id => "1", :section_id => "2") 
    end

    it "recognizes and generates #update" do
      { :put => "/tasks/1" }.should route_to(:controller => "tasks", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/tasks/1" }.should route_to(:controller => "tasks", :action => "destroy", :id => "1") 
    end

    it "recognizes and generates #state" do
      { :put => "/tasks/1/state" }.should route_to(:controller => "tasks", :action => "state", :id => "1") 
    end
  end
end
