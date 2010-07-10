require 'spec_helper'

describe ProjectsController do
  describe "with admin user" do
    before do
      sign_in Factory(:user, :admin => true)
    end
    
    describe "GET index" do
      it "renders index template" do
        get :index
        response.should render_template(:index)
      end
    end

    describe "GET show" do
      it "assigns the requested project as @project" do
        Project.stub(:find).with("37").and_return(mock_project)
        get :show, :id => "37"
        assigns[:project].should equal(mock_project)
      end
    end

    describe "GET new" do
      it "assigns a new project as @project" do
        Project.stub(:new).and_return(mock_project)
        get :new
        assigns[:project].should equal(mock_project)
      end
    end

    describe "GET edit" do
      it "assigns the requested project as @project" do
        Project.stub(:find).with("37").and_return(mock_project)
        get :edit, :id => "37"
        assigns[:project].should equal(mock_project)
      end
    end

    describe "POST create" do

      describe "with valid params" do
        it "assigns a newly created project as @project" do
          Project.stub(:new).with({'these' => 'params'}).and_return(mock_project(:save => true))
          post :create, :project => {:these => 'params'}
          assigns[:project].should equal(mock_project)
        end

        it "redirects to the created project" do
          Project.stub(:new).and_return(mock_project(:save => true))
          post :create, :project => {}
          response.should redirect_to(project_url(mock_project))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved project as @project" do
          Project.stub(:new).with({'these' => 'params'}).and_return(mock_project(:save => false))
          post :create, :project => {:these => 'params'}
          assigns[:project].should equal(mock_project)
        end

        it "re-renders the 'new' template" do
          Project.stub(:new).and_return(mock_project(:save => false))
          post :create, :project => {}
          response.should render_template('new')
        end
      end

    end

    describe "PUT update" do

      describe "with valid params" do
        it "updates the requested project" do
          Project.should_receive(:find).with("37").and_return(mock_project)
          mock_project.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :project => {:these => 'params'}
        end

        it "assigns the requested project as @project" do
          Project.stub(:find).and_return(mock_project(:update_attributes => true))
          put :update, :id => "1"
          assigns[:project].should equal(mock_project)
        end

        it "redirects to the project" do
          Project.stub(:find).and_return(mock_project(:update_attributes => true))
          put :update, :id => "1"
          response.should redirect_to(project_url(mock_project))
        end
      end

      describe "with invalid params" do
        it "updates the requested project" do
          Project.should_receive(:find).with("37").and_return(mock_project)
          mock_project.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :project => {:these => 'params'}
        end

        it "assigns the project as @project" do
          Project.stub(:find).and_return(mock_project(:update_attributes => false))
          put :update, :id => "1"
          assigns[:project].should equal(mock_project)
        end

        it "re-renders the 'edit' template" do
          Project.stub(:find).and_return(mock_project(:update_attributes => false))
          put :update, :id => "1"
          response.should render_template('edit')
        end
      end

    end

    describe "DELETE destroy" do
      it "destroys the requested project" do
        Project.should_receive(:find).with("37").and_return(mock_project)
        mock_project.should_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the projects list" do
        Project.stub(:find).and_return(mock_project(:destroy => true))
        delete :destroy, :id => "1"
        response.should redirect_to(projects_url)
      end
    end

    describe "PUT complete" do
      before do
        Project.should_receive(:find).with("1").and_return mock_project
        mock_project.should_receive(:completed=).with("foo")
        mock_project.should_receive(:save)
        
        put :complete, :id => "1", :complete => "foo"
      end
      
      it "should set completed flag to project" do
      end
      
      it { should redirect_to(project_url(mock_project)) }
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
