require 'spec_helper'

describe "/tasks/search.html.erb" do
  before do
    assigns[:tasks] = [ Factory(:task) ]
  end

  it "renders" do
    render
  end
end
