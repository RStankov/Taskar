require 'spec_helper'

describe "/users/show" do
  before do
    assigns[:user] = @user = Factory(:user)
    
    sign_in Factory(:user)
  end

  it "renders" do
    render
  end
end
