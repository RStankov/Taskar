require 'spec_helper'

describe "/sections/show.html.erb" do
  before(:each) do
    assigns[:section] = @section = Factory(:section)
    assigns[:project] = @project = @section.project
    
    tasks = [Factory(:task)]
    
    @section.should_receive(:tasks).and_return(tasks)
    tasks.should_receive(:unarchived).and_return(tasks)
  end

  it "should renders" do
    render
  end
end
