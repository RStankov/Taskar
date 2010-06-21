require 'spec_helper'

describe "/users/edit" do
  before do
    assigns[:user] = @user = Factory(:user)
  end

  it "renders" do
    render
  end
end
