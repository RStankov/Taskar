require 'spec_helper'

describe TasksController do

  def mock_task(stubs={})
    @mock_task ||= mock_model(Task, {:section => mock_section}.merge(stubs))
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
    it "assigns the requested task as @task" do
      Task.stub(:find).with("37").and_return(mock_task)
      get :show, :id => "37"
      assigns[:task].should equal(mock_task)
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
      it "assigns a newly created task as @task" do
        Task.stub(:build).with({'these' => 'params'}).and_return(mock_task(:save => true))
        post :create, :task => {:these => 'params'}, :project_id => "1", :section_id => "2"
        assigns[:task].should equal(mock_task)
      end

      it "redirects to the created task" do
        Task.stub(:build).and_return(mock_task(:save => true))
        post :create, :task => {}, :project_id => "1", :section_id => "2"
        response.should redirect_to(project_section_url(mock_project, mock_section))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved task as @task" do
        Task.stub(:build).with({'these' => 'params'}).and_return(mock_task(:save => false))
        post :create, :task => {:these => 'params'}, :project_id => "1", :section_id => "2"
        assigns[:task].should equal(mock_task)
      end

      it "re-renders the 'new' template" do
        Task.stub(:build).and_return(mock_task(:save => false))
        post :create, :task => {}, :project_id => "1", :section_id => "2"
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested task" do
        Task.should_receive(:find).with("37").and_return(mock_task)
        mock_task.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :task => {:these => 'params'}
      end

      it "assigns the requested task as @task" do
        Task.stub(:find).and_return(mock_task(:update_attributes => true))
        put :update, :id => "1"
        assigns[:task].should equal(mock_task)
      end

      it "redirects to the task" do
        Task.stub(:find).and_return(mock_task(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(task_url(mock_task))
      end
    end

    describe "with invalid params" do
      it "updates the requested task" do
        Task.should_receive(:find).with("37").and_return(mock_task)
        mock_task.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :task => {:these => 'params'}
      end

      it "assigns the task as @task" do
        Task.stub(:find).and_return(mock_task(:update_attributes => false))
        put :update, :id => "1"
        assigns[:task].should equal(mock_task)
      end

      it "re-renders the 'edit' template" do
        Task.stub(:find).and_return(mock_task(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested task" do
      Task.should_receive(:find).with("37").and_return(mock_task)
      mock_task.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the tasks list" do
      Task.stub(:find).and_return(mock_task(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(project_section_url(mock_project, mock_section))
    end
  end

end
