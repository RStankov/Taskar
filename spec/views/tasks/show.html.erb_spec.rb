require 'spec_helper'

describe "/tasks/show.html.erb" do
  before do
    assigns[:task] = @task = Factory(:task)
  end

  it "renders" do
    render
  end
end