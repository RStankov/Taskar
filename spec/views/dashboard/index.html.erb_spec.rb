require 'spec_helper'

describe "/dashboard/index" do
  before do
    assigns[:projects] = [ Factory(:project) ]
  end
  
  it "should render" do
    render
  end
end
