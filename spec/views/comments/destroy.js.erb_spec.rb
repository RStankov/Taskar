require 'spec_helper'

describe "/comments/destroy.js.erb" do
  before do    
    assigns[:comment] = Factory(:comment)
  end

  it "should render" do
    render
  end
end