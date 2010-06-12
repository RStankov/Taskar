require 'spec_helper'

describe "/sections/show.html.erb" do
  before(:each) do
    assigns[:section] = @section = Factory(:section)
    assigns[:project] = @project = @section.project
  end

  it "should renders" do
    render
  end
end
