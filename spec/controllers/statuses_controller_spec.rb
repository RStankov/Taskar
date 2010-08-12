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
          
          controller.should_receive(:activity).with mock_status
        end
        
        describe "xhr request" do
          before { xhr :post, :create, :project_id => "1", :status => {:these => "params"} }
          
          it { should assign_to(:status).with(mock_status) }
          it { should_not render_template("create") }
          it { response.should be_success }
        end
        
        describe "normal request" do
          before { post :create, :project_id => "1", :status => {:these => "params"} }

          it { should assign_to(:status).with(mock_status) }
          it { should redirect_to(project_statuses_url(mock_project)) }
        end
      end
      
      describe "with invali data" do
        before { mock_status.should_receive(:save).and_return false }
        
        describe "xhr request" do
          before { xhr :post, :create, :project_id => "1", :status => {:these => "params"} }
          
          it { should assign_to(:status).with(mock_status) }
          it { should_not render_template("create") }
          it { response.should be_success }
        end
        
        describe "normal request" do
          before { post :create, :project_id => "1", :status => {:these => "params"} }

          it { should assign_to(:status).with(mock_status) }
          it { should redirect_to(project_statuses_url(mock_project)) }
        end
      end
    end
    
    describe "GET index" do
      before do
        mock_project.should_receive(:statuses).and_return @mock_statuses = [mock_status]
        @mock_statuses.should_receive(:paginate).with(:page => "2", :per_page => 20, :order => "id DESC").and_return @mock_statuses
        
        get :index, :project_id => "1", :page => "2"
      end
      
      it { should assign_to(:statuses).with(@mock_statuses) }
      it { should render_template("index") }
    end

    describe "DELETE clear" do
      before do
        controller.should_receive(:project_user).and_return mock_user
        
        mock_user.should_receive(:update_attribute).with(:status, "")
      end
      
      it "should redirect on normal request" do
        delete :clear, :project_id => "1"
        
        should redirect_to(project_statuses_url(mock_project))
      end
      
      it "should just head :ok on xhr request" do
        controller.should_receive(:head).with(:ok)
        
        xhr :delete, :clear, :project_id => "1"
      end
    end

    describe "DELETE status" do
      before do
        @current_user.stub_chain(:statuses, :find => mock_status)
        
        mock_status.should_receive(:destroy)
      end
      
      it "should redirect on normal request" do
        delete :destroy, :project_id => "1", :id => "1"

        should redirect_to(project_statuses_url(mock_project))
      end

      it "should just head :ok on xhr request" do
        controller.should_receive(:head).with(:ok)

        xhr :delete, :destroy, :project_id => "1", :id => "1"
      end
    end
  end
  
  describe "with user outside project" do
    before { sign_with_user_outside_the_project }
    
    {
      :create     => 'post(:create, :project_id => "1")',
      :index      => 'get(:index, :project_id =>"1")',
      :clear      => 'delete(:clear, :project_id =>"1")'
    }.each do |(action, code)|
     it "should not allow #{action}, and redirect_to root_url" do
       eval code
     end
    end
  end

end
