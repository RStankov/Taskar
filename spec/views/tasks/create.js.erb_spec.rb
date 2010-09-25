require 'spec_helper'

describe "/tasks/create.js.erb" do
  before do
    sign_in Factory(:user)

    assign :task, @task = Factory(:task)
  end

  it "contains '#tasks' text, when @task don't higher_item" do
    render
    rendered.should include('$("tasks")')
  end

  it "contains higher_item.id text, when @task don't higher_item" do
    @task.stub!(:higher_item).and_return(mock_task(:id => 12345))

    render
    rendered.should include('$("task_12345")')
  end
end