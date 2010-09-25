require 'spec_helper'

describe "/tasks/search.html.erb" do
  before do
    assign :tasks, [ Factory(:task) ]
    assign :limit, 20
  end

  it "renders" do
    assign :total, 30

    render
  end

  it "shows empty text if there isn't any results" do
    assign :total, 0

    render
    rendered.should have_selector("li.unselectable", :content => t("tasks.show.no_results_found"))
  end

  it "shows more text if total is more than limit" do
    assign :total, 30

    render
    rendered.should have_selector("li.unselectable", :content => t("tasks.show.more_results", :count => 30 - 20))
  end

  it "don't show more text if total is not more than limit" do
    assign :total, 10

    render
    rendered.should_not have_selector("li.unselectable", :content => t("tasks.show.more_results", :count => 10))
  end

end
