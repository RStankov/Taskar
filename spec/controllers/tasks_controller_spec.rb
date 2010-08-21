require 'spec_helper'

describe TasksController do
  describe "with project user" do
    before { sign_with_project_user }

    def controller_should_fire_event
      controller.should_receive(:activity).with(mock_task)
    end
    
    def redirect_to_section_url(params = {})
      redirect_to section_url(mock_section, params)
    end

    def redirect_to_task_url
      redirect_to task_url(mock_task)
    end

    describe "member action" do
      before do
        Task.should_receive(:find).with("1").and_return mock_task(:editable? => true)
      end
 
      describe "GET show" do
        before { get :show, :id => "1" }
        
        it { should assign_to(:task).with(mock_task) }
        it { should assign_to(:section).with(mock_section) }
        it { should assign_to(:project).with(mock_project) }
      end

      describe "GET edit" do
        before { get :edit, :id => "1" }
        
        it { should assign_to(:task).with(mock_task) }
      end

      describe "PUT update" do
        before do
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

          describe "normal request" do
            before { put :update, params }
            
            it { should assign_to(:task).with(mock_task) }
            it { should redirect_to_task_url }
          end
          
          describe "xhr request" do
            before { xhr :put, :update, params }
            
            it { should assign_to(:task).with(mock_task) }
            it { should render_template("show") }
          end
        end

        describe "with invalid params" do
          before do
            mock_task.should_receive(:update_attributes).with("these" => "params").and_return(false)
            
            put :update, params
          end

          it { should assign_to(:task).with(mock_task) }
          it { should render_template('edit') }
        end
      end

      describe "DELETE destroy" do
        before do
          controller_should_fire_event
          
          mock_task.should_receive(:destroy)
        end
        
        describe "normal request" do
          before { delete :destroy, :id => "1" }
          
          it { should assign_to(:task).with(mock_task) }
          it { should redirect_to_section_url }
        end
        
        describe "xhr request" do
          before { xhr :delete, :destroy, :id => "1" }
          
          it { should assign_to(:task).with(mock_task) }
          it { should_not redirect_to_section_url }
        end
      end

      describe "PUT state" do
        before do          
          mock_task.stub!(:save).and_return true
          mock_task.should_receive(:state=).with("fooo")

          controller_should_fire_event
          
          xhr :put, :state, :id => "1", :state => "fooo"
        end

        it { should assign_to(:task).with(mock_task) }
        it { response.should be_success }
      end

      describe "PUT archive" do
        before do
          mock_task.stub!(:save).and_return true
          mock_task.stub!(:archived=)

          controller_should_fire_event
        end

        it "should try to archive the task to true, when archived is true" do
          mock_task.should_receive(:archived=).with(true)

          xhr :put, :archive, :id => "1", :archived => "true"
        end

        it "should try to archive the task to false, when archived is set to false" do
          mock_task.should_receive(:archived=).with(false)

          xhr :put, :archive, :id => "1"
        end

        it "should just head ok" do
          xhr :put, :archive, :id => "1", :archived => "true"

          response.should be_success
        end
      end
      
      describe "PUT section" do
        before do
          mock_task.should_receive(:update_attribute).with(:section_id, "2")
          
          put :section, :id => "1", :section_id => "2"
        end
        
        it { should_not render_template("secrion") }
        it { response.should be_success }
      end

      describe "ensure_task_is_editable filter" do
        before do
          mock_task.should_receive(:editable?).and_return(false)
        end

        it "should render :show action on xhr request" do
          xhr :get, :edit, :id => "1"

          should render_template(:show)
        end

        it "should redirect to @task on normal request" do
          get :edit, :id => "1"

          should redirect_to_task_url
        end
      end
    end
    
    describe "Section collection action" do
      before { Section.stub(:find).with("2").and_return(mock_section) }
      
      describe "POST create" do
        before { @current_user.should_receive(:new_task).with(mock_section, {'these' => 'params'}).and_return mock_task }
        
        def params
          {:task => {:these => 'params'}, :section_id => "2"}
        end
        
        describe "with valid params" do
          before do
            mock_task.should_receive(:save).and_return true

            controller_should_fire_event
          end
          
          describe "with norma request" do
            before { post :create, params }
            
            it { should assign_to(:task).with(mock_task) }
            it { should redirect_to_section_url(:anchor => "task_#{mock_task.id}") }
          end
          
          describe "with xhr request" do
            before { xhr :post, :create, params }
            
            it { should assign_to(:task).with(mock_task) }
            it { should render_template("create") }
          end
        end

        describe "with invalid params" do
          before do
            mock_task.should_receive(:save).and_return false
            
            post :create, params
          end

          it { should assign_to(:task).with(@task) }
          it { should render_template("_new") }
        end

      end
      
      describe "GET archived" do
        before do
          mock_section.should_receive(:tasks).and_return @tasks = [mock_task]
          @tasks.should_receive(:archived).and_return @tasks
          
          xhr :get, :archived, :section_id => "2"
        end

        it { should assign_to(:section).with(mock_section) }
        it { should assign_to(:tasks).with(@tasks) }
        it { should render_template("archived") }
      end

    end
    
    describe "Project collection action" do
      before { Project.should_receive(:find).with("3").and_return(mock_project) }
    
      describe "GET index" do
        before do
          @current_user.should_receive(:responsibilities).and_return @mock_tasks = [mock_task]
          @mock_tasks.should_receive(:opened_in_project).with(mock_project).and_return @mock_tasks

          get :index, :project_id => "3"
        end

        it { should assign_to(:tasks).with(@mock_tasks) }
        it { should render_template("index") }
      end
      
      describe "GET search" do
        before do
          mock_project.should_receive(:tasks).and_return @mock_tasks = [mock_task]

          @mock_tasks.should_receive(:unarchived).and_return @mock_tasks
          @mock_tasks.should_receive(:search).with("term").and_return @mock_tasks

          get :search, :project_id => "3", :ss => "term"
        end
        
        it { should assign_to(:tasks).with(@mock_tasks) }
        it { should render_template("search") }
      end

      describe "PUT reorder" do
        before do
          mock_project.should_receive(:tasks).and_return  mock_tasks = []
          mock_tasks.should_receive(:reorder).with(["1", "2", "3", "4"])
          
          xhr :put, :reorder, :project_id => "3", :items => ["1", "2", "3", "4"]
        end
        
        it { should_not render_template("reorder") }
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
      :archive    => 'put(:archive, :id => "1")',
      :section    => 'put(:section, :id => "1")'
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
      :index      => 'get(:index, :project_id => "1")',
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