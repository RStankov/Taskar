require 'spec_helper'

describe "/accounts/projects/new.html.erb" do
  before(:each) do
    sign_in Factory(:user)

    assign :account, @account = Factory(:account)
    assign :project, Project.new
  end

  it "renders new project form" do
    render

    rendered.should have_selector("form[action=\"#{account_projects_path(@account)}\"][method=post]")
  end
end
