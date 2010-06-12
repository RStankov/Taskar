require 'spec_helper'

describe "/tasks/show.html.erb" do
  before(:each) do
    assigns[:task] = @task = stub_model(Task,
      :section => 1,
      :text => "value for text",
      :status => 1,
      :position => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/value\ for\ text/)
    response.should have_text(/1/)
    response.should have_text(/1/)
  end
end
