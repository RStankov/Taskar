require 'spec_helper'

describe "/projects/index.html.erb" do
  include ProjectsHelper

  before(:each) do
    assigns[:projects] = [
      stub_model(Project,
        :name => "value for name"
      ),
      stub_model(Project,
        :name => "value for name"
      )
    ]
  end

  it "renders a list of projects" do
    render
    response.should have_tag("tr>td", "value for name".to_s, 2)
  end
end
