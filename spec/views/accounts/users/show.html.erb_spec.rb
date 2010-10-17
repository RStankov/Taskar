require 'spec_helper'

describe "/accounts/users/show" do
  before do
    assign :account, Factory(:account)
    assign :user, Factory(:user)

    sign_in Factory(:user)
  end

  it "renders" do
    render
  end
end
