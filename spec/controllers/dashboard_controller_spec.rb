require 'spec_helper'

describe DashboardController do
  before do
    sign_in @current_user = Factory(:user)
  end

  describe "GET 'index'" do
    before do
      controller.stub(:current_user).and_return(@current_user)
      @current_user.should_receive(:projects).and_return([@mock_project = mock(Project)])
    end
    
    it "should touch the current user last_active_at field" do
      @current_user.should_receive(:touch).with(:last_active_at)
      
      get "index"
    end
    
    it "should assign current_user.projects as @projects" do
      get "index"
      
      assigns[:projects].should == [@mock_project]
    end
    
    it "should be successful" do
      get "index"
  
      response.should render_template(:index)
    end
  end
end
