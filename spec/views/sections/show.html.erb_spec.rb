require 'spec_helper'

describe "/sections/show.html.erb" do
  before(:each) do
    sign_in Factory(:user) 
        
    assigns[:section] = @section = Factory(:section)
    assigns[:project] = @project = @section.project
    
    @tasks = [Factory(:task)]
  end

  it "should render active tasks"  do
    @section.stub!(:archive?).and_return(false)    
    @section.should_receive(:tasks).and_return(@tasks)
    @tasks.should_receive(:unarchived).and_return(@tasks)
    
    render
    
    response.should have_tag('#tasks')
    response.should have_tag('#section_footer')
  end
  
  it "should render archived tasks and no forms" do
    @section.stub!(:archived?).and_return(true)
    @section.should_receive(:tasks).and_return(@tasks)
    @tasks.should_receive(:archived).and_return(@tasks)
    
    render
    
    response.should_not have_tag('#tasks')
    response.should_not have_tag('#section_footer')
    response.should have_tag('.tasks_list')
  end
end
