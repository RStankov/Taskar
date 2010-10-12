require 'spec_helper'

describe "/users/new" do
  before do
    assign :account, Factory(:account)
    assign :user, User.new
  end

  it "renders" do
    render
  end
end
