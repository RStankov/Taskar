require 'spec_helper'

describe "/projects/index.html.erb" do
  before do
    assign :projects,  [stub_model(Project)]
    assign :completed, [stub_model(Project)].paginate
  end

  it { render }
end
