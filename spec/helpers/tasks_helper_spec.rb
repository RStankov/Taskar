require 'spec_helper'

describe TasksHelper do
  describe "task_state_checkbox" do
    before do
      @task = mock_task(:state => "opened")
    end
    
    describe "on not archived task" do
      before do
        @task.stub!(:archived?).and_return(false)
        @returned = helper.task_state_checkbox(@task)
      end
      
      it "should return span.checkbox" do
        @returned.should have_tag("span.checkbox")
      end

      it "should return span.(@task.state)" do
        @returned.should have_tag("span.checkbox.#{@task.state}")
      end

      it "should return span[data-state]" do
        @returned.should have_tag("span[data-state=#{@task.state}]")
      end

      it "should return span[data-url]" do
        url = state_task_path(@task)
        @returned.should have_tag("span[data-url=#{url}]")
      end
    end
    
    describe "on archived task" do
      before do
        @task.stub!(:state).and_return("complete")
        @task.stub!(:archived?).and_return(true)
        @returned = helper.task_state_checkbox(@task)
      end
      
      it "should return span.checkbox" do
        @returned.should have_tag("span.checkbox")
      end

      it "should return span.(@task.state)" do
        @returned.should have_tag("span.checkbox.#{@task.state}")
      end

      it "should not return span[data-state]" do
        @returned.should_not have_tag("span[data-state=#{@task.state}]")
      end

      it "should not return span[data-url]" do
        url = state_task_path(@task)
        @returned.should_not have_tag("span[data-url=#{url}]")
      end
    end
  end
  
  describe "task_description" do
    it "returns tasks description in p" do
      expected  = ('<p>' + t(:'tasks.show.description', :from => 'Радослав Станков', :to => 'Някой друг', :on => '10.05.2010', :due => '10.05.2010') + '</p>')
      
      helper.task_description(mock_task).should == expected
    end
  end
end