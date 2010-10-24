require 'spec_helper'

describe "/accounts/users/show" do
  before do
    assign :account, Factory.stub(:account)
    assign :user, Factory.stub(:user)
    assign :projects, [Factory.stub(:project)]

    sign_in Factory(:user)
  end

  it { render }
end
