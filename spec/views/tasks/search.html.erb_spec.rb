require 'spec_helper'

describe "/tasks/search.html.erb" do
  before do
    assigns[:tasks] = [ Factory(:task) ]
    assigns[:limit] = 20 
  end

  it "renders" do
    assigns[:total] = 30
  
    render
  end
  
  it "shows empty text if there isn't any results" do
    assigns[:total] = 0
    
    render
    
    response.should have_tag("li.unselectable", :text => t("tasks.show.no_results_found"))
  end
  
  it "shows more text if total is more than limit" do
    assigns[:total] = 30
    
    render
    
    response.should have_tag("li.unselectable", :text => t("tasks.show.more_results", :count => assigns[:total] - assigns[:limit]))
  end
  
  it "don't show more text if total is not more than limit" do
    assigns[:total] = 10
    
    render
    
    response.should_not have_tag("li.unselectable", :text => t("tasks.show.more_results", :count => assigns[:total]))
  end
  
end
