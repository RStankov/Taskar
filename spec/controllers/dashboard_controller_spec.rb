require 'spec_helper'

describe DashboardController do
  before { sign_in Factory(:user) }

  describe "GET 'index'" do
    before do
      controller.stub_chain :current_user, :projects, :active => [mock_project]
      
      get :index
    end
    
    it { should assign_to(:projects).with([mock_project]) }
    it { should render_template("index") }
  end
end
