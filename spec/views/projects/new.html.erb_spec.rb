require 'spec_helper'

describe "/projects/new.html.erb" do
  before(:each) do
    sign_in Factory(:user)

    assign :account, Factory(:account)
    assign :project, Project.new
  end

  it "renders new project form" do
    render

    rendered.should have_selector("form[action=\"#{projects_path}\"][method=post]")
  end
end
