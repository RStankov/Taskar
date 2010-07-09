require 'spec_helper'

describe "/sections/show.html.erb" do
  before do
    sign_in Factory(:user) 
        
    assigns[:section] = @section = Factory(:section)
    assigns[:project] = @project = @section.project
    assigns[:tasks]   = @tasks   = [Factory(:task)]
  end

  it "should render active tasks"  do
    @section.stub!(:archive?).and_return(false)    
    
    render
    
    response.should have_tag('#tasks')
    response.should have_tag('#section_footer')
  end
  
  it "should render archived tasks and no forms" do
    @section.stub!(:archived?).and_return(true)
    
    render
    
    response.should_not have_tag('#tasks')
    response.should_not have_tag('#section_footer .add')
    response.should_not have_tag('#section_footer .more')
    response.should have_tag('.tasks_list')
  end
end
