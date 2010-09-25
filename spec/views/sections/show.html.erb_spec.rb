require "spec_helper"

describe "/sections/show.html.erb" do
  before do
    sign_in Factory(:user)

    assign :section, @section = Factory(:section)
    assign :project, @project = @section.project
    assign :tasks,   @tasks   = [Factory(:task)]
  end

  it "should render active tasks"  do
    @section.stub!(:archive?).and_return false

    render

    rendered.should have_selector("#tasks")
    rendered.should have_selector("footer")
  end

  it "should render archived tasks and no forms" do
    @section.stub!(:archived?).and_return true

    render

    rendered.should_not have_selector("#tasks")
    rendered.should_not have_selector("footer .add")
    rendered.should_not have_selector("footer .more")
    rendered.should have_selector(".tasks_list")
  end
end
