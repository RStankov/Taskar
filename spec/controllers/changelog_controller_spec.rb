require 'spec_helper'

describe ChangelogController do
  before { sign_in Factory(:user) }

  describe "GET 'index'" do
    it "should be successful" do
      get :index
      should render_template("index")
    end
  end

end
