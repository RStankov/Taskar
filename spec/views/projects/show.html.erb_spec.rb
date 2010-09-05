require 'spec_helper'

describe "/projects/show.html.erb" do
  before(:each) do    
    assigns[:project]  = Factory(:project) 
    assigns[:sections] = [Factory(:section)]
  end

  it "renders" do
    render
  end
end
