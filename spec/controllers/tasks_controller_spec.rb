require 'spec_helper'

describe TasksController do
  describe "with project user" do
    before { sign_with_project_user }

    def controller_should_fire_event
      controller.should_receive(:activity).with(mock_task)
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

      it "assigns taks's section project as @project" do
        assigns[:project].should == mock_project
      end
    end

    describe "GET edit" do
      it "assigns the requested task as @task" do
        Task.stub(:find).with("37").and_return(mock_task(:editable? => true))

        get :edit, :id => "37"

        assigns[:task].should equal(mock_task)
      end
    end

    describe "POST create" do
      before do
        Section.stub(:find).with("2").and_return(mock_section)
      end

      describe "with valid params" do
        before do
          @current_user.should_receive(:new_task).with(mock_section, {'these' => 'params'}).and_return(mock_task(:save => true))

          controller_should_fire_event
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
        before do
          @current_user.should_receive(:new_task).with(mock_section, {'these' => 'params'}).and_return(mock_task(:save => false))
          post :create, :task => {:these => 'params'}, :section_id => "2"
        end

        it "assigns a newly created but unsaved task as @task" do
          assigns[:task].should equal(mock_task)
        end

        it "re-renders the 'new' template" do
          response.should render_template(:_new)
        end
      end

    end

    describe "PUT update" do
      before do
        Task.should_receive(:find).with("1").and_return(mock_task(:editable? => true))
        controller.should_receive(:ensure_task_is_editable)
      end

      def params
        {:id => "1", :task => {:these => 'params'}}
      end

      describe "with valid params" do
        before do
          mock_task.should_receive(:update_attributes).with("these" => "params").and_return(true)

          controller_should_fire_event
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

        controller_should_fire_event

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
        mock_task.stub!(:state=)

        controller_should_fire_event
      end

      it "updates state attribute" do
        mock_task.should_receive(:state=).with("fooo")

        xhr :put, :state, :id => "5", :state => "fooo"
      end

      it "returns ok" do
        xhr :put, :state, :id => "5"

        response.should be_success
      end
    end

    describe "PUT reorder" do
      before do
        Project.should_receive(:find).with("3").and_return(mock_project)
        mock_project.should_receive(:tasks).and_return(Task)
      end

      it "should reorder the given ids" do
        Task.should_receive(:reorder).with(["1", "2", "3", "4"])

        xhr :put, :reorder, :project_id => "3", :items => ["1", "2", "3", "4"]
      end

      it "should not render template" do
        xhr :put, :reorder, :project_id => "3"

        response.should_not render_template(:reorder)
        response.should be_success
      end
    end

    describe "GET search" do
      before do
        @tasks = [mock_task]

        Project.should_receive(:find).with("3").and_return(mock_project)
        mock_project.should_receive(:tasks).and_return(@tasks)

        @tasks.should_receive(:unarchived).and_return(@tasks)
        @tasks.should_receive(:search).with("term").and_return(@tasks)

        get :search, :project_id => "3", :ss => "term"
      end

      it "should search for given :ss" do
      end

      it "should assign founded tasks as @tasks" do
        assigns[:tasks].should == @tasks
      end

      it "should render search template" do
        response.should render_template(:search)
      end
    end

    describe "PUT archive" do
      before do
        Task.stub!(:find).with("5").and_return(mock_task(:save => true))
        mock_task.stub!(:archived=)

        controller_should_fire_event
      end

      it "should try to archive the task to true, when archived is true" do
        mock_task.should_receive(:archived=).with(true)

        xhr :put, :archive, :id => "5", :archived => "true"
      end

      it "should try to archive the task to false, when archived is set to false" do
        mock_task.should_receive(:archived=).with(false)

        xhr :put, :archive, :id => "5"
      end

      it "should just head ok" do
        xhr :put, :archive, :id => "5", :archived => "true"

        response.should be_success
      end
    end

    describe "GET archived" do
      before do
        @tasks = [mock_task]

        Section.should_receive(:find).with("1").and_return(mock_section)
        mock_section.should_receive(:tasks).and_return(@tasks)
        @tasks.should_receive(:archived).and_return(@tasks)

        xhr :get, :archived, :section_id => "1"
      end

      it "should assign the selected section as @section" do
        assigns[:section] = mock_section
      end

      it "should get section archived items, and assign them as @tasks" do
        assigns[:tasks] = @tasks
      end

      it "should render archived template" do
        response.should render_template(:archived)
      end
    end

    describe "ensure_task_is_editable filter" do
      before do
        Task.stub(:find).with("1").and_return(mock_task)
        mock_task.should_receive(:editable?).and_return(false)
      end

      it "should render :show action on xhr request" do
        xhr :get, :edit, :id => "1"

        response.should render_template(:show)
      end

      it "should redirect to @task on normal request" do
        get :edit, :id => "1"

        response.should redirect_to(task_url(mock_task))
      end
    end
  end

  describe "with user outside project" do
    before { sign_with_user_outside_the_project }

    {
      :show       => 'get(:show, :id => "1")',
      :edit       => 'get(:edit, :id => "1")',
      :update     => 'put(:update, :id => "1")',
      :destroy    => 'delete(:destroy, :id => "1")',
      :state      => 'put(:state, :id => "1")',
      :archive    => 'put(:archive, :id => "1")'
    }.each do |(action, code)|
      it "should not allow #{action}, and redirect_to root_url" do
        Task.should_receive(:find).with("1").and_return(mock_task)

        eval code
      end
    end

    {
      :create     => 'post(:create, :section_id => "1")',
      :archived   => 'get(:archived, :section_id => "1")'
    }.each do |(action, code)|
      it "should not allow #{action}, and redirect_to root_url" do
        Section.should_receive(:find).with("1").and_return(mock_section)

        eval code
      end
    end

    {
      :reorder    => 'get(:reorder, :project_id => "1")',
      :search     => 'get(:search, :project_id => "1")'
    }.each do |(action, code)|
      it "should not allow #{action}, and redirect_to root_url" do
        Project.should_receive(:find).with("1").and_return(mock_project)

        eval code
      end
    end
  end
end