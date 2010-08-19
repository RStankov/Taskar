require 'spec_helper'

describe "/sections/index.html.erb" do
  it "should renders" do
    assigns[:events]  = [ Factory(:event) ].paginate
    assigns[:project] = mock_project
    
    render
  end
end
