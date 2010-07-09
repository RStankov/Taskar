require 'spec_helper'

describe "/sections/show.print.erb" do
  before do
    assigns[:section] = @section = Factory(:section)
    assigns[:project] = @project = @section.project
    assigns[:tasks]   = @tasks   = [Factory(:task)]
  end

  it "should render"  do
    render
  end
end
