require 'spec_helper'

describe "devise/invitations/show.html.erb" do
  before { assign :invitation, Factory.stub(:invitation, :token => "foo", :account => Factory.stub(:account, :owner => Factory.stub(:user))) }

  it { render }
end
