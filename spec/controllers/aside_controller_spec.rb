require 'spec_helper'

describe AsideController do
  describe "with project user" do
    before { sign_with_project_user }
    
    describe "GET index" do
      it "should render json with current user responsibilities_count" do
        Project.should_receive(:find).with("1").and_return(mock_project)
        @current_user.should_receive(:responsibilities_count).with(mock_project.id).and_return(321)
        
        mock_project.should_receive(:participants).and_return participants = [1,2,3]
        
        xhr :get, :index, :project_id => "1"
        
        should assign_to(:responsibilities_count).with(321)
        should assign_to(:participants).with(participants)
        should render_template("index.js")
      end
    end
  end
  
  describe "with user outside project" do
    before { sign_with_user_outside_the_project }
    
    {
      :index      => 'get(:index, :project_id => "1")'
    }.each do |(action, code)|
      it "should not allow #{action}, and redirect_to root_url" do
         Project.should_receive(:find).with("1").and_return(mock_project)
        
        eval code
      end
    end
  end
end
