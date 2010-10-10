require 'spec_helper'

describe DashboardController do
  subject { controller }

  before do
    sign_in @current_user = Factory(:user)
    controller.stub(:current_user).and_return @current_user
  end

  describe "GET 'index'" do
    context "when there are more than 1 projects" do
      before do
        @current_user.stub_chain :projects, :active, :order => @mock_projects = [mock_project, mock_project]

        get :index
      end

      it { should assign_to(:projects).with(@mock_projects) }
    end

    context "when there is one project and user is admin" do
      before do
        @current_user.stub_chain :projects, :active, :order => @mock_projects = [mock_project]
        @current_user.stub(:admin?).and_return true

        get :index
      end

      it { should assign_to(:projects).with(@mock_projects) }
    end

    context "when there is one project and user is not admin" do
      before do
        @current_user.stub_chain :projects, :active, :order => @mock_projects = [mock_project]
        @current_user.stub(:admin?).and_return false

        get :index
      end

      it { should redirect_to(project_sections_url(mock_project)) }
    end
  end
end
