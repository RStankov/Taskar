require 'spec_helper'

describe "/accounts/users/edit" do
  before do
    assign :account, Factory(:account)
    assign :user, Factory(:user)
  end

  it { render }
end
