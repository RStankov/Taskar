require 'spec_helper'

describe AsideController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/projects/1/aside" }.should route_to(:controller => "aside", :action => "index", :project_id => "1")
    end
  end
end
