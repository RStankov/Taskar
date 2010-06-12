require 'spec_helper'

describe "/tasks/index.html.erb" do
  before(:each) do
    assigns[:tasks] = [
      stub_model(Task,
        :section => 1,
        :text => "value for text",
        :status => 1,
        :position => 1
      ),
      stub_model(Task,
        :section => 1,
        :text => "value for text",
        :status => 1,
        :position => 1
      )
    ]
  end

  it "renders a list of tasks" do
    render
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for text".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end
