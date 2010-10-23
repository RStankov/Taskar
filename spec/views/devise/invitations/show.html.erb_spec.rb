require 'spec_helper'

describe "devise/invitations/show.html.erb" do
  before { assign :invitation, Factory(:invitation) }

  it { render }
end
