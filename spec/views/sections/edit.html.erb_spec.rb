require 'spec_helper'

describe "/sections/edit.html.erb" do
  include SectionsHelper

  before(:each) do
    assigns[:project] = @project = stub_model(Project)
    assigns[:section] = @section = stub_model(Section,
      :new_record? => false,
      :project => 1,
      :name => "value for name",
      :position => 1
    )
  end

  it "should renders" do
    render
  end
end
