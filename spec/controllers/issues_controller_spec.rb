require 'spec_helper'

describe IssuesController do
  subject { controller }

  before do
    sign_in @current_user = Factory(:user)

    controller.stub(:current_user).and_return @current_user
  end

  describe "GET create" do
    it "should create new user issue" do
      @current_user.should_receive(:issues).and_return user_issues = stub(Object)
      user_issues.should_receive(:create).with("these" => "params")

      post "create", :issue => {:these => "params"}

      should_not render_template("create")
    end
  end
end
