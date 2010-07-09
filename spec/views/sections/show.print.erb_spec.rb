require 'spec_helper'

describe "/sections/show.print.erb" do
  before(:each) do
    sign_in Factory(:user) 
        
    assigns[:section] = @section = Factory(:section)
    assigns[:project] = @project = @section.project
    
    @tasks = [Factory(:task)]
  end

  it "should render with active tasks when not archived"  do
    @section.stub!(:archive?).and_return(false)    
    @section.should_receive(:tasks).and_return(@tasks)
    @tasks.should_receive(:unarchived).and_return(@tasks)
    
    render
  end
  
  it "should render archived tasks when archived" do
    @section.stub!(:archived?).and_return(true)
    @section.should_receive(:tasks).and_return(@tasks)
    @tasks.should_receive(:archived).and_return(@tasks)
    
    render
  end
end
