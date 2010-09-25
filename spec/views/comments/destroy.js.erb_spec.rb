require 'spec_helper'

describe "/comments/destroy.js.erb" do
  before do
    assign :comment, Factory(:comment)
  end

  it { render }
end