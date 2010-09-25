require 'spec_helper'

describe DashboardController do
  subject { controller }

  before { sign_in Factory(:user) }

  describe "GET 'index'" do
    context "when there are more than 1 projects" do
      before do
        controller.stub_chain :current_user, :projects, :active => @mock_projects = [mock_project, mock_project]

        get :index
      end

      it { should assign_to(:projects).with(@mock_projects) }
    end

    context "when there is one project and user is admin" do
      before do
        controller.stub_chain :current_user, :projects, :active => @mock_projects = [mock_project]
        controller.stub_chain :current_user, :admin? => true

        get :index
      end

      it { should assign_to(:projects).with(@mock_projects) }
    end

    context "when there is one project and user is not admin" do
      before do
        controller.stub_chain :current_user, :projects, :active => @mock_projects = [mock_project]
        controller.stub_chain :current_user, :admin? => false

        get :index
      end

      it { should redirect_to(project_sections_url(mock_project)) }
    end
  end
end
