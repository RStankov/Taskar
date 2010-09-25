require 'spec_helper'

describe "/tasks/archived.html.erb" do
  before do
    sign_in Factory(:user)

    assign :section, Factory(:section)
    assign :tasks,   [Factory(:task)]
  end

  it { render }
end
