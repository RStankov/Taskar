require 'spec_helper'

describe "/users/index" do
  before do
    assigns[:users] = @users = [Factory(:user)]
  end

  it "renders" do
    render
  end
end
