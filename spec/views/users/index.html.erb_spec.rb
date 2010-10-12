require 'spec_helper'

describe "/users/index" do
  before do
    assign :account, Factory(:account)
    assign :users, [Factory(:user)]
  end

  it { render }
end
