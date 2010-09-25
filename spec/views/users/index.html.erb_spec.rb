require 'spec_helper'

describe "/users/index" do
  before do
    assign :users, [Factory(:user)]
  end

  it { render }
end
