require 'spec_helper'

describe "/projects/edit.html.erb" do
  include ProjectsHelper

  before(:each) do
    assigns[:project] = @project = stub_model(Project,
      :new_record? => false,
      :name => "value for name"
    )
  end

  it "renders the edit project form" do
    render

    response.should have_tag("form[action=#{project_path(@project)}][method=post]") do
      with_tag('input#project_name[name=?]', "project[name]")
    end
  end
end
