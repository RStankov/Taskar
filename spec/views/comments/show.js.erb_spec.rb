require 'spec_helper'

describe "/comments/show.js.erb" do
  before do    
    assigns[:comment] = Factory(:comment)
    
    template.stub!(:current_user).and_return(Factory(:user))
  end

  it "should render" do
    render
  end
end