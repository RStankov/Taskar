require 'spec_helper'

describe IssuesController do
  describe "routing" do
    it "recognizes and generates #create" do
      { :post => "/issues" }.should route_to(:controller => "issues", :action => "create")
    end
  end
end
