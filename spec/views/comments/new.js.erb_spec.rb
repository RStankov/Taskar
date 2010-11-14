require 'spec_helper'

describe "/comments/new.js.erb" do
  before do
    assign :comment, Comment.new
    assign :task, Factory.stub(:task)
  end

  it { render }
end