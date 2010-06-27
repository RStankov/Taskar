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
    before do
      mock_user(:full_name => 'Radoslav Stankov')
      mock_task(:created_at => Time.now - 1.week, :responsible_party => nil)
    end
    
    def task_description
      helper.task_description(mock_task)
    end
    
    def expected(name, options = {})
      '<p>' + 
        t(:"tasks.show.description.#{name}", {
          :from => mock_user.full_name, 
          :on   => helper.time_ago_in_words(mock_task.created_at)
        }.merge(options)) + 
      '</p>'
    end
    
    it "should return short version if task have only creator and created at" do
      task_description.should == expected(:short)
    end
    
    it "should return responsible if there is responsible party" do
      mock_task.stub!(:responsible_party).and_return(mock(User, :full_name => 'Dobromir Raynov'))
      
      task_description.should == expected(:responsible, :to => 'Dobromir Raynov')
    end
    
    it "should return same if responsible party is same as creator" do
      mock_task.stub!(:responsible_party).and_return(mock_user)
      
      task_description.should == expected(:same)
    end
    
    # TODO: when due is added to task
    #it "returns tasks description in p" do
    #  helper.task_description(mock_task).should == expected(:full, :to => 'Някой друг', :due => '10.05.2010')
    #end
  end
end