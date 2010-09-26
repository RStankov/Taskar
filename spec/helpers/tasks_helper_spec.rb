require "spec_helper"

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
        @returned.should have_selector("span.checkbox")
      end

      it "should return span.(@task.state)" do
        @returned.should have_selector("span.checkbox.#{@task.state}")
      end

      it "should return span[data-state]" do
        @returned.should have_selector("span[data-state=#{@task.state}]")
      end

      it "should return span[data-url]" do
        url = state_task_path(@task)
        @returned.should have_selector("span[data-url=\"#{url}\"]")
      end

      it "should not return span[data-disabled]" do
        url = state_task_path(@task)
        @returned.should_not have_selector("span[data-disabled]")
      end
    end

    describe "on archived task" do
      before do
        @task.stub!(:state).and_return("complete")
        @task.stub!(:archived?).and_return(true)
        @returned = helper.task_state_checkbox(@task)
      end

      it "should return span.checkbox" do
        @returned.should have_selector("span.checkbox")
      end

      it "should return span.(@task.state)" do
        @returned.should have_selector("span.checkbox.#{@task.state}")
      end

      it "should return span[data-state]" do
        @returned.should have_selector("span[data-state=#{@task.state}]")
      end

      it "should return span[data-url]" do
        url = state_task_path(@task)
        @returned.should have_selector("span[data-url=\"#{url}\"]")
      end

      it "should return span[data-disabled]" do
        url = state_task_path(@task)
        @returned.should have_selector("span[data-disabled]")
      end
    end
  end

  describe "task_description" do
    before do
      mock_user(:full_name => "Radoslav Stankov")
      mock_task(:created_at => Time.now - 1.week, :responsible_party => nil)
    end

    def task_description(stubs = {})
      stubs.each { |method, value| mock_task.stub(method).and_return(value)  }
      helper.task_description(mock_task)
    end

    def expected(task_type, name, options = {})
      t(:"tasks.show.description.#{name}", {
        :task => t("tasks.show.task.#{task_type}"),
        :from => mock_user.full_name,
        :on   => helper.time_ago_in_words(mock_task.created_at)
      }.merge(options))
    end

    it "should return short version if task have only creator and created at" do
      task_description(:archived => false).should == expected(:normal, :short)
      task_description(:archived => true).should == expected(:archived, :short)
    end

    it "should return responsible if there is responsible party" do
      mock_task.stub!(:responsible_party).and_return(mock(User, :full_name => "Metodi Stankov"))

      task_description(:archived => false).should == expected(:normal, :responsible, :to => "Metodi Stankov")
      task_description(:archived => true).should == expected(:archived, :responsible, :to => "Metodi Stankov")
    end

    it "should return same if responsible party is same as creator" do
      mock_task.stub!(:responsible_party).and_return(mock_user)

      task_description(:archived => false).should == expected(:normal, :same)
      task_description(:archived => true).should == expected(:archived, :same)
    end
  end
end