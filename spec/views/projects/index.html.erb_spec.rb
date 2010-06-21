require 'spec_helper'

describe "/projects/index.html.erb" do
  before(:each) do
    assigns[:projects] = [stub_model(Project)]
  end

  it "renders" do
    render
  end
end
