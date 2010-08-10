require 'spec_helper'

describe StatusesController do
  describe "routing" do
    it "recognizes and generates #create" do
      { :post => "/projects/1/statuses" }.should route_to(:controller => "statuses", :action => "create", :project_id => "1") 
    end
    
    it "recognizes and generates #index" do
      { :get => "/projects/1/statuses" }.should route_to(:controller => "statuses", :action => "index", :project_id => "1")
    end
    
    it "recognizes and generates #update" do
      { :delete => "/projects/1/statuses/clear" }.should route_to(:controller => "statuses", :action => "clear", :project_id => "1")
    end
  end
end
