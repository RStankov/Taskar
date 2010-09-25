require 'spec_helper'

describe "/sections/index.html.erb" do
  before do
    assign :sections, [ Factory(:section) ]
  end

  it { render }
end
