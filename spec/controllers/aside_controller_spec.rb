require 'spec_helper'

describe AsideController do
  describe "with project user" do
    before { sign_with_project_user }
    
    describe "GET index" do
      it "should render json with current user responsibilities_count" do
        Project.should_receive(:find).with("1").and_return(mock_project)
        @current_user.should_receive(:responsibilities_count).with(mock_project.id).and_return(321)
        
        get :index, :project_id => "1", :format => "json"
        
        should assign_to(:responsibilities_count).with(321)
        should render_template("index.json")
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
