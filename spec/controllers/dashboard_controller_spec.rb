require 'spec_helper'

describe DashboardController do
  subject { controller }

  before do
    sign_in @current_user = Factory(:user)
    controller.stub(:current_user).and_return @current_user
  end

  describe "GET 'index'" do
    it "should display the recent projects" do
      @current_user.stub_chain :projects, :active, :limit => @mock_projects = [mock_project]

      get :index

      should assign_to(:projects).with(@mock_projects)
      should render_template("index")
    end
  end
end
