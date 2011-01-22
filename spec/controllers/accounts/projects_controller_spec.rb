require 'spec_helper'

describe Accounts::ProjectsController do
  before { sign_up_and_mock_account }

  let(:current_user){ @current_user }
  let(:account){ mock_account }
  let(:project){ mock_project }
  let(:projects){ [project] }
  let(:section){ mock_section }
  let(:sections){ [section] }

  describe "with admin user" do
    before do
      account.should_receive(:admin?).with(current_user).and_return true
      account.stub :projects => projects

      projects.stub :find => project
    end

    describe "GET index" do
      before { projects.stub :completed => "completed projects" }
      before { projects.stub :active => "active projects" }
      before { get :index, :account_id => "1" }

      it { should assign_to(:projects).with("active projects") }
      it { should assign_to(:completed).with("completed projects") }
      it { should render_template(:index) }
    end

    describe "GET new" do
      before { projects.stub :build => project }
      before { get :new, :account_id => "1" }

      it { should assign_to(:project).with(project) }
      it { should render_template(:new) }
    end

    describe "POST create" do
      before { projects.should_receive(:build).with({'these' => 'params'}).and_return project }

      describe "with valid params" do
        before { project.stub :save => true }
        before { post :create, :account_id => "1", :project => {:these => 'params'} }

        it { should assign_to(:project).with(project) }
        it { should redirect_to(tasks_project_sections_url(project)) }
      end

      describe "with invalid params" do
        before { project.stub :save => false }
        before { post :create, :account_id => "1", :project => {:these => 'params'} }

        it { should assign_to(:project).with(project) }
        it { should render_template(:new) }
      end
    end

    describe "GET show" do
      before { project.stub_chain :sections, :order => [section] }
      before { get :show, :account_id => "1", :id => "2" }

      it { should assign_to(:sections).with(sections) }
      it { should assign_to(:project).with(project) }
      it { should render_template(:show) }
    end

    describe "GET edit" do
      before { get :edit, :account_id => "1", :id => "2" }

      it { should assign_to(:project).with(project) }
      it { should render_template(:edit) }
    end

    describe "PUT update" do
      describe "with valid params" do
        before { project.should_receive(:update_attributes).with({'these' => 'params'}).and_return true }
        before { put :update, :account_id => "1", :id => "2", :project => {:these => 'params'} }

        it { should assign_to(:project).with(project) }
        it { should set_the_flash }
        it { should redirect_to(account_project_url(account, project)) }
      end

      describe "with invalid params" do
        before { project.should_receive(:update_attributes).with({'these' => 'params'}).and_return false }
        before { put :update, :account_id => "1", :id => "2", :project => {:these => 'params'} }

        it { should assign_to(:project).with(project) }
        it { should render_template("edit") }
      end
    end

    describe "DELETE destroy" do
      before { project.should_receive(:destroy) }
      before { delete :destroy, :account_id => "1", :id => "2" }

      it { should redirect_to(account_projects_url(account)) }
    end

    describe "PUT complete" do
      before do
        project.stub :completed=
        project.stub :save
        project.stub :completed => true
      end

      it "should set completed flag to project to true" do
        project.should_receive(:completed=).with(true)
        project.should_receive(:save)

        put :complete, :account_id => "1", :id => "2", :complete => "foo"
      end

      it "should set completed flag to project to false" do
        project.should_receive(:completed=).with(false)
        project.should_receive(:save)

        put :complete, :account_id => "1", :id => "2"
      end

      it "sets the flash" do
        project.stub(:completed=)

        put :complete, :account_id => "1", :id => "2"

        should set_the_flash
      end

      it "redirects back to the projecs pages" do
        project.stub(:completed=)

        put :complete, :account_id => "1", :id => "2"

        should redirect_to(account_project_url(account, project))
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
