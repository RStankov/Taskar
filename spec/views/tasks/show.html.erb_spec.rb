require 'spec_helper'

describe "/tasks/show.html.erb" do
  before do
    assign :task, Factory(:task)
  end

  it { render }
end
