require 'spec_helper'

describe "/comments/new.js.erb" do
  before do    
    assigns[:comment] = Factory(:comment)
  end

  it "should render" do
    render
  end
end