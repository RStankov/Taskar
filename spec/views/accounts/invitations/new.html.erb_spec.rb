require 'spec_helper'

describe "accounts/invitations/new.html.erb" do
  before do
    assign :account, Factory.stub(:account)
    assign :invitation, Invitation.new
  end

  it { render }
end
