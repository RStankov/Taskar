require 'spec_helper'

describe "/sections/index.html.erb" do
  before do
    assigns[:events] = [ Factory(:event) ].paginate
  end

  it "should renders" do
    render
  end
end
