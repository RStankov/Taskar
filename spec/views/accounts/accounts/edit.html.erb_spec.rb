require 'spec_helper'

describe "/accounts/accounts/edit.html.erb" do
  before do
    assign :account, Factory(:account)
  end

  it { render }
end
