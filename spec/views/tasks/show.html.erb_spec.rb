require 'spec_helper'

describe "/tasks/show.html.erb" do
  before do
    assign :task, Factory(:task)
    assign :section, Factory(:section)
  end

  it { render }
end
