require 'spec_helper'

describe "/projects/index.html.erb" do
  before do
    assigns[:projects]  = [stub_model(Project)]
    assigns[:completed] = [stub_model(Project)].paginate
  end

  it "renders" do
    render
  end
end
