require 'spec_helper'

describe "/accounts/accounts/show.html.erb" do
  before do
    assign :account, Factory(:account)
  end

  it { render }
end
