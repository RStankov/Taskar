require 'spec_helper'

describe "accounts/show.html.erb" do
  before do
    assign :account, Factory(:account)
  end

  it { render }
end
