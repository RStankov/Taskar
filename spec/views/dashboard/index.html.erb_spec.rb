require 'spec_helper'

describe "/dashboard/index" do  
  it "should render empty dashboard message" do
    sign_in Factory(:user)
    
    assigns[:projects] = []
    
    render
    
    response.should have_tag('.empty_dashboard')
    response.should_not have_tag('#events')
  end
  
  it "should render events table if projects exists" do
    assigns[:projects] = [ Factory(:project) ]
        
    render
    
    response.should_not have_tag('.empty_dashboard')
    response.should have_tag('#events')
  end
end
