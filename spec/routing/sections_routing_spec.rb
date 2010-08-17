require 'spec_helper'

describe SectionsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/projects/1/sections" }.should route_to(:controller => "sections", :action => "index", :project_id => "1")
    end

    it "recognizes and generates #new" do
      { :get => "/projects/1/sections/new" }.should route_to(:controller => "sections", :action => "new", :project_id => "1")
    end
    
    it "recognizes and generates #create" do
      { :post => "/projects/1/sections" }.should route_to(:controller => "sections", :action => "create", :project_id => "1") 
    end

    it "recognizes and generates #show" do
      { :get => "/sections/1" }.should route_to(:controller => "sections", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/sections/1/edit" }.should route_to(:controller => "sections", :action => "edit", :id => "1")
    end
    
    it "recognizes and generates #update" do
      { :put => "/sections/1" }.should route_to(:controller => "sections", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/sections/1" }.should route_to(:controller => "sections", :action => "destroy", :id => "1") 
    end
    
    it "recognizes and generates #reorder" do
      { :put => "projects/1/sections/reorder" }.should route_to(:controller => "sections", :action => "reorder", :project_id => "1") 
    end
    
    it "recognizes and generates #archive" do
      { :put => "/sections/1/archive" }.should route_to(:controller => "sections", :action => "archive", :id => "1") 
    end

    it "recognizes and generates #tasks" do
      { :get => "projects/1/sections/tasks" }.should route_to(:controller => "sections", :action => "tasks", :project_id => "1") 
    end
  end
end
