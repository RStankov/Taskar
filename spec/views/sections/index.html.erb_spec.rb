require 'spec_helper'

describe "/sections/index.html.erb" do
  before(:each) do
    assigns[:project] = @project = stub_model(Project)
    assigns[:sections] = [
      stub_model(Section,
        :project => 1,
        :name => "value for name",
        :position => 1
      ),
      stub_model(Section,
        :project => 1,
        :name => "value for name",
        :position => 1
      )
    ]
  end

  it "should renders" do
    render
  end
end
