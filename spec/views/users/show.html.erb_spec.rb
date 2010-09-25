require 'spec_helper'

describe "/users/show" do
  before do
    @user = Factory(:user)

    assign :user, @user

    sign_in @user
  end

  it "renders" do
    render
  end
end
