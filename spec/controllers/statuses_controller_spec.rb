require 'spec_helper'

describe StatusesController do
  before { Project.should_receive(:find).with("1").and_return mock_project }
  
  describe "with project user" do
    before { sign_with_project_user }
    
    def controller_should_fire_event
      controller.should_receive(:activity).with(mock_status)
    end
    
    describe "POST create" do
      before { @current_user.should_receive(:new_status).with(mock_project, {"these" => "params"}).and_return mock_status }
      
      describe "with valid data" do
        before do
          mock_status.should_receive(:save).and_return true
          
          xhr :post, :create, :project_id => "1", :status => {:these => "params"}
        end
        
        it { should assign_to(:status).with(mock_status) }
        it { should render_template("create")}
      end
      
      describe "with invali data" do
        before do
          mock_status.should_receive(:save).and_return false

          xhr :post, :create, :project_id => "1", :status => {:these => "params"}
        end
        
        it { should assign_to(:status).with(mock_status) }
        it { should render_template("create")}
      end
    end
    
    describe "GET index" do
      before do
        mock_project.should_receive(:statuses).and_return @mock_statuses = [mock_status]
        @mock_statuses.should_receive(:paginate).with(:page => "2", :per_page => 30).and_return @mock_statuses
        
        get :index, :project_id => "1", :page => "2"
      end
      
      it { should assign_to(:statuses).with(@mock_statuses) }
      it { should render_template("index") }
    end

  end
  
  describe "with user outside project" do
    before { sign_with_user_outside_the_project }
    
    {
      :create     => 'post(:create, :project_id => "1")',
      :index      => 'get(:index, :project_id =>"1")'
    }.each do |(action, code)|
     it "should not allow #{action}, and redirect_to root_url" do
       eval code
     end
    end
  end

end
