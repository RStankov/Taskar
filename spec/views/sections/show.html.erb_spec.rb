require 'spec_helper'

describe "/sections/show.html.erb" do
  include SectionsHelper
  before(:each) do
    assigns[:project] = @project = stub_model(Project)
    assigns[:section] = @section = stub_model(Section,
      :project => 1,
      :name => "value for name",
      :position => 1
    )
  end

  it "should renders" do
    render
  end
end
