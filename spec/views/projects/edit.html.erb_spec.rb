require 'spec_helper'

describe "/projects/edit.html.erb" do
  before(:each) do
    sign_in Factory(:user)

    assign :account, Factory(:account)
    assign :project, @project = stub_model(Project,
      :new_record?  => false,
      :name         => "value for name"
    )
  end

  it "renders the edit project form" do
    render

    rendered.should have_selector("form[action=\"#{project_path(@project)}\"][method=post]")
  end
end
