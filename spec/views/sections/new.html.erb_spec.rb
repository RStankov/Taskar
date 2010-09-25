require 'spec_helper'

describe "/sections/new.html.erb" do
  before(:each) do
    assign :project, @project = stub_model(Project)
    assign :section, stub_model(Section,
      :new_record? => true,
      :project => 1,
      :name => "value for name",
      :position => 1
    )
  end

  it { render }
end
