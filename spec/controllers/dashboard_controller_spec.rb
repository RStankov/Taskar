require 'spec_helper'

describe DashboardController do
  subject { controller }

  before do
    sign_in @current_user = Factory(:user)
    controller.stub(:current_user).and_return @current_user
  end

  describe "GET 'index'" do
    before do
      @current_user.stub_chain :projects, :active, :order => @mock_projects = [mock_project]

      get :index
    end

    it { should assign_to(:projects).with(@mock_projects) }
    it { should render_template("index") }
  end
end
