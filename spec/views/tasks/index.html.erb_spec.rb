require 'spec_helper'

describe "/tasks/index.html.erb" do
  before do
    sign_in Factory(:user)
    
    assigns[:tasks] = [Factory(:task)]
  end

  it "renders" do
    render
  end
end
