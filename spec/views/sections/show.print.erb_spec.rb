require 'spec_helper'

describe "/sections/show.print.erb" do
  before do
    assign :section, @section = Factory(:section)
    assign :project, @section.project
    assign :tasks,   [Factory(:task)]
  end

  it { render }
end
