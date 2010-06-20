require 'spec_helper'

describe TasksHelper do
  describe "task_state_checkbox" do
    before do
      @task = mock_model(Project, {:state => "opened"})
      
      @returned = helper.task_state_checkbox(@task)
    end
    
    it "returns span.checkbox" do
      @returned.should have_tag("span.checkbox")
    end
    
    it "returns span.(@task.state)" do
      @returned.should have_tag("span.checkbox.#{@task.state}")
    end
    
    it "returns span[data-state]" do
      @returned.should have_tag("span[data-state=#{@task.state}]")
    end
    
    it "returns span[data-url]" do
      url = state_task_path(@task)
      @returned.should have_tag("span[data-url=#{url}]")
    end
  end
  
  describe "task_description" do
    it "returns tasks description in p" do
      task      = mock_model(Task)
      expected  = ('<p>' + t(:'tasks.show.description', :from => 'Радослав Станков', :to => 'Някой друг', :on => '10.05.2010', :due => '10.05.2010') + '</p>')
      
      helper.task_description(task).should == expected
    end
  end
end