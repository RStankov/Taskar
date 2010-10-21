require 'spec_helper'

describe "/accounts/users/index" do
  before do
    assign :account, Factory.stub(:account)
    assign :users, [Factory.stub(:user)]
    assign :invitations, [Factory.stub(:invitation)]
  end

  it { render }
end
