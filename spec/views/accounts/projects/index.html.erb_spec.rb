require 'spec_helper'

describe "/accounts/projects/index.html.erb" do
  before do
    assign :account, Factory(:account)
    assign :projects,  [stub_model(Project)]
    assign :completed, [stub_model(Project)].paginate
  end

  it { render }
end
