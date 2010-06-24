require 'spec_helper'

describe "/tasks/archived.html.erb" do
  before do
    assigns[:section] = Factory(:section)
    assigns[:tasks]   = [Factory(:task)]
  end

  it "renders" do
    render
  end
end
