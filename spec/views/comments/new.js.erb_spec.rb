require 'spec_helper'

describe "/comments/new.js.erb" do
  before do
    assign :comment, Factory(:comment)
  end

  it { render }
end