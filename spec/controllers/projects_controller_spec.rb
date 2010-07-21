require 'spec_helper'

describe ProjectsController do
  describe "with admin user" do
    before do
      sign_in @current_user = Factory(:user, :admin => true)
    end
    
    describe "on collection action" do
      describe "GET index" do
        before do
          Project.should_receive(:completed).and_return([@completed = mock(Project)])
          Project.should_receive(:active).and_return([@active = mock(Project)])

          get :index
        end

        it { should assign_to(:projects).with([@active]) }
        it { should assign_to(:completed).with([@completed]) }
        it { should render_template("index") }
      end
      
      describe "GET new" do
        before do
          Project.stub(:new).and_return(mock_project)
          get :new
        end
        
        it { should assign_to(:project).with(mock_project) }
        it { should render_template("new") }
      end

      describe "POST create" do
        def project_should_take_account_from_current_user
          mock_project.should_receive(:account=).with(@current_user.account)
        end

        describe "with valid params" do
          it "assigns a newly created project as @project" do
            Project.stub(:new).with({'these' => 'params'}).and_return(mock_project(:save => true))
            
            project_should_take_account_from_current_user

            post :create, :project => {:these => 'params'}
            assigns[:project].should equal(mock_project)
          end

          it "redirects to the created project" do
            Project.stub(:new).and_return(mock_project(:save => true))

            project_should_take_account_from_current_user

            post :create, :project => {}
            response.should redirect_to(project_url(mock_project))
          end
        end

        describe "with invalid params" do
          it "assigns a newly created but unsaved project as @project" do
            Project.stub(:new).with({'these' => 'params'}).and_return(mock_project(:save => false))

            project_should_take_account_from_current_user

            post :create, :project => {:these => 'params'}
            assigns[:project].should equal(mock_project)
          end

          it "re-renders the 'new' template" do
            Project.stub(:new).and_return(mock_project(:save => false))

            project_should_take_account_from_current_user

            post :create, :project => {}
            response.should render_template('new')
          end
        end

      end
      
    end
    
    describe "on member action" do
      before do
        Project.should_receive(:find).with("1").and_return(mock_project)
      end
      
      describe "GET show" do
        before { get :show, :id => "1" }
        
        it { should assign_to(:project).with(mock_project) }
        it { should render_template("show") }
      end

      describe "GET edit" do
        before { get :edit, :id => "1" }
        
        it { should assign_to(:project).with(mock_project) }
        it { should render_template("edit") }
      end

      describe "PUT update" do
        describe "with valid params" do
          before do
            mock_project.should_receive(:update_attributes).with({'these' => 'params'}).and_return true
            put :update, :id => "1", :project => {:these => 'params'}
          end

          it { should assign_to(:project).with(mock_project) }
          it { should redirect_to(project_url(mock_project)) }
        end

        describe "with invalid params" do
          before do
            mock_project.should_receive(:update_attributes).with({'these' => 'params'}).and_return false
            put :update, :id => "1", :project => {:these => 'params'}
          end

          it { should assign_to(:project).with(mock_project) }
          it { should render_template("edit") }
        end
      end

      describe "DELETE destroy" do
        before do
          mock_project.should_receive(:destroy)
          delete :destroy, :id => "1"
        end
        
        it { should redirect_to(projects_url) }
      end

      describe "PUT complete" do
        before do
          mock_project.stub(:completed=)
          mock_project.stub(:save)
        end

        it "should set completed flag to project to true" do
          mock_project.should_receive(:completed=).with(true)
          mock_project.should_receive(:save)

          put :complete, :id => "1", :complete => "foo"
        end

        it "should set completed flag to project to false" do
          mock_project.should_receive(:completed=).with(false)
          mock_project.should_receive(:save)

          put :complete, :id => "1"
        end

        it do
          put :complete, :id => "1", :complete => "foo"

          should redirect_to(project_url(mock_project)) 
        end
      end
    end
  end

  describe "with normal user" do
    before do
      sign_in Factory(:user)
      
      ensure_deny_access_is_called
    end
    
    {
      :index      => 'get(:index)',
      :show       => 'get(:show, :id => "1")',
      :new        => 'get(:new)',
      :create     => 'post(:create)',
      :edit       => 'get(:edit, :id => "1")',
      :update     => 'put(:update, :id => "1")',
      :destroy    => 'delete(:destroy, :id => "1")',
      :complete   => 'put(:complete, :id=>"1")'
    }.each do |(action, code)|
      it "should not allow #{action}, and redirect_to root_url" do
        eval code
      end
    end
  end
end
