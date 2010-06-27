require 'spec_helper'

describe "/tasks/archived.html.erb" do
  before do
    sign_in Factory(:user) 
        
    assigns[:section] = Factory(:section)
    assigns[:tasks]   = [Factory(:task)]
  end

  it "renders" do
    render
  end
end
