require 'spec_helper'

describe "/sections/show.html.erb" do
  before(:each) do
    assigns[:section] = @section = Factory(:section)
    assigns[:project] = @project = @section.project
    
    @section.should_receive(:tasks).and_return([Factory(:task)])
  end

  it "should renders" do
    render
  end
end
