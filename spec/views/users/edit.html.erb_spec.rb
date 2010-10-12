require 'spec_helper'

describe "/users/edit" do
  before do
    assign :account, Factory(:account)
    assign :user, Factory(:user)
  end

  it { render }
end
