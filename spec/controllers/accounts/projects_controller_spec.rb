require 'spec_helper'

describe Accounts::ProjectsController do
  let(:account)      { mock_model(Account) }
  let(:current_user) { mock_model(User) }
  let(:user)         { mock_model(User) }
  let(:project)      { mock_model(Project) }
  let(:projects)     { double }

  before do
    controller.stub :authenticate_user!
    controller.stub :current_user => current_user

    current_user.stub :find_account => account

    account.stub :projects => projects
  end

  describe "with admin user" do
    before do
      account.should_receive(:admin?).with(current_user).and_return true

      projects.stub :find => project
    end

    describe "GET index" do
      it "renders index template" do
        get :index, :account_id => '1'

        controller.should render_template 'index'
      end
    end

    describe "GET show" do
      it "assigns the project as @project" do
        projects.should_receive(:find).with('2').and_return project

        get :show, :account_id => '1', :id => '2'

        controller.should assign_to(:project).with(project)
      end
    end

    describe "GET edit" do
      it "assigns the project as @project" do
        projects.should_receive(:find).with('2').and_return project

        get :edit, :account_id => '1', :id => '2'

        controller.should assign_to(:project).with(project)
      end
    end

    describe "GET new" do
      it "assings new project as @project" do
        projects.should_receive(:build).and_return project

        get :new, :account_id => '1'

        controller.should assign_to(:project).with(project)
      end
    end

    describe "POST create" do
      before do
        projects.stub :build => project
        project.stub :save
      end

      it "assigns the project as @project" do
        projects.should_receive(:build).with('these' => 'params').and_return project

        post :create, :account_id => '1', :project => {:these => 'params'}

        controller.should assign_to(:project).with(project)
      end

      it "creates new project" do
        project.should_receive(:save)

        post :create, :account_id => '1'
      end

      it "redirects to the projects tasks page if projects is created succesfully" do
        project.stub :save => true

        post :create, :account_id => '1'

        controller.should redirect_to tasks_project_sections_url(project)
      end

      it "renders new page if project is not created succesfully" do
        project.stub :save => false

        post :create, :account_id => '1'

        controller.should render_template 'new'
      end
    end

    describe "PUT update" do
      before { project.stub :update_attributes }

      it "assigns the project as @project" do
        projects.should_receive(:find).with('2').and_return project

        put :update, :account_id => '1', :id => '2'

        controller.should assign_to(:project).with(project)
      end

      it "updates the project" do
        project.should_receive(:update_attributes).with 'these' => 'params'

        put :update, :account_id => '1', :id => '2', :project => {:these => 'params'}
      end

      it "redirects to account project page if projects is updated succesfully" do
        project.stub :update_attributes => true

        put :update, :account_id => '1', :id => '2'

        controller.should redirect_to account_project_path(account, project)
      end

      it "renders edit page if project is not updated succesfully" do
        project.stub :update_attributes => false

        put :update, :account_id => '1', :id => '2'

        controller.should render_template 'edit'
      end
    end

    describe "DELETE destroy" do
      before { project.stub :destroy }

      it "destroys an project" do
        project.should_receive(:destroy)

        delete :destroy, :account_id => '1', :id => '2'
      end

      it "redirects to account projects" do
        delete :destroy, :account_id => '1', :id => '2'

        controller.should redirect_to account_projects_path(account)
      end
    end

    describe "PUT complete" do
      before do
        project.stub :completed=
        project.stub :save
        project.stub :completed => true
      end

      it "can set completed flag to project to true" do
        project.should_receive(:completed=).with(true)
        project.should_receive(:save)

        put :complete, :account_id => '1', :id => '2', :complete => 'true'
      end

      it "can set completed flag to project to false" do
        project.should_receive(:completed=).with(false)
        project.should_receive(:save)

        put :complete, :account_id => "1", :id => "2"
      end

      it "redirects to account project page with flash message" do
        project.stub(:completed=)

        put :complete, :account_id => "1", :id => "2"

        controller.should redirect_to account_project_path(account, project)
        controller.should set_the_flash
      end
    end
  end

  describe "with normal user" do
    before do
      account.should_receive(:admin?).with(current_user).and_return false

      ensure_deny_access_is_called
    end

    {
      :index      => 'get(:index, :account_id => "1")',
      :show       => 'get(:show, :account_id => "1", :id => "2")',
      :new        => 'get(:new, :account_id => "1")',
      :create     => 'post(:create, :account_id => "1")',
      :edit       => 'get(:edit, :account_id => "1", :id => "2")',
      :update     => 'put(:update, :account_id => "1", :id => "2")',
      :destroy    => 'delete(:destroy, :account_id => "1", :id => "2")',
      :complete   => 'put(:complete, :account_id => "1", :id=>"2")'
    }.each do |(action, code)|
      it "should not allow #{action}, and redirect_to root_url" do
        eval code
      end
    end
  end
end
