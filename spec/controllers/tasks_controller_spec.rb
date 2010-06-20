require 'spec_helper'

describe TasksController do

  def mock_task(stubs={})
    @mock_task ||= mock_model(Task, {:section => mock_section, :project => mock_project}.merge(stubs))
  end
  
  def mock_section(stubs={})
    @mock_section ||= mock_model(Section, {:project => mock_project}.merge(stubs))
  end

  def mock_project(stubs={})
    @mock_project ||= mock_model(Project, stubs)
  end

  before do
    sign_in Factory(:user)
  end

  describe "GET show" do
    before do
      Task.stub(:find).with("37").and_return(mock_task)
      get :show, :id => "37"
    end
    
    it "assigns the requested task as @task" do
      assigns[:task].should == mock_task
    end
    
    it "assigns task's section as @section" do
      assigns[:section].should == mock_section
    end
  end

  describe "GET edit" do
    it "assigns the requested task as @task" do
      Task.stub(:find).with("37").and_return(mock_task)
      get :edit, :id => "37"
      assigns[:task].should equal(mock_task)
    end
  end

  describe "POST create" do
    before do
      Section.stub(:find).with("2").and_return(mock_section)
      mock_section.stub(:tasks).and_return(Task)
    end
    
    describe "with valid params" do
      before do
        Task.stub(:build).with({'these' => 'params'}).and_return(mock_task(:save => true))
      end
      
      def params
        {:task => {:these => 'params'}, :section_id => "2"}
      end
      
      it "assigns a newly created task as @task" do
        post :create, params
        
        assigns[:task].should equal(mock_task)
      end

      it "redirects to the created task" do
        post :create, params
        
        response.should redirect_to(section_url(mock_section, :anchor => "task_#{mock_task.id}"))
      end
      
      it "renders create.rjs on xhr request" do
        xhr :post, :create, params
        
        response.should render_template("create")
      end
      
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved task as @task" do
        Task.stub(:build).with({'these' => 'params'}).and_return(mock_task(:save => false))
        post :create, :task => {:these => 'params'}, :section_id => "2"
        assigns[:task].should equal(mock_task)
      end

      it "re-renders the 'new' template" do
        Task.stub(:build).and_return(mock_task(:save => false))
        post :create, :task => {}, :section_id => "2"
        response.should render_template("_new")
      end
    end

  end

  describe "PUT update" do
    before do
      Task.should_receive(:find).with("1").and_return(mock_task)
    end
    
    def params
      {:id => "1", :task => {:these => 'params'}}
    end
    
    describe "with valid params" do
      before do
        mock_task.should_receive(:update_attributes).with("these" => "params").and_return(true)
      end
      
      it "updates the requested task" do
        put :update, params
      end

      it "assigns the requested task as @task" do
        put :update, params
        assigns[:task].should equal(mock_task)
      end

      it "renders show action if xhr" do
        xhr :put, :update, params
        response.should render_template("show")
      end
      
      it "redirects to tasks_url if not xhr" do
        put :update, params
        response.should redirect_to(task_url(mock_task))        
      end
    end

    describe "with invalid params" do
      before do
        mock_task.should_receive(:update_attributes).with("these" => "params").and_return(false)
      end
      
      it "updates the requested task" do
        put :update, params
      end

      it "assigns the task as @task" do
        put :update, params
        assigns[:task].should equal(mock_task)
      end

      it "re-renders the 'edit' template" do
        put :update, params
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    before do
      Task.should_receive(:find).with("37").and_return(mock_task)
      mock_task.should_receive(:destroy)
    end
    
    def redirect_to_section_url
      redirect_to(section_url(mock_section))
    end
    
    it "destroys the requested task" do
      delete :destroy, :id => "37"
    end

    it "redirects to the tasks list" do
      delete :destroy, :id => "37"
      response.should redirect_to_section_url
    end
    
    it "returns ok when this is xhr request" do
      xhr :delete, :destroy, :id => "37"
      
      response.should be_success
      response.should_not redirect_to_section_url
    end
  end
  
  describe "PUT state" do
    before do
      Task.stub!(:find).with("5").and_return(mock_task(:save => true))
    end
    
    it "updates state attribute" do
      mock_task.should_receive(:state=).with("fooo")
      
      xhr :put, :state, :id => "5", :state => "fooo"
    end
    
    it "returns ok" do
      mock_task.stub!(:state=)
      
      xhr :put, :state, :id => "5"
      
      response.should be_success
    end
  end

  describe "PUT reorder" do
    it "should call Tasks.reorder with the given ids" do
      Task.should_receive(:reorder).with(["1", "2", "3", "4"])
      
      xhr :put, :reorder, :items => ["1", "2", "3", "4"]
    end
    
    it "should not render template" do
      xhr :put, :reorder
      
      response.should_not render_template(:reorder)
      response.should be_success
    end
  end
end
