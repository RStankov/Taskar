require 'spec_helper'

describe "/projects/show.html.erb" do
  before(:each) do
    assign :account, Factory(:account)
    assign :project,  Factory(:project)
    assign :sections, [Factory(:section)]
  end

  it { render }
end
