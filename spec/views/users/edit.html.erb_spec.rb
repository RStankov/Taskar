require 'spec_helper'

describe "/users/edit" do
  before do
    assign :user, Factory(:user)
  end

  it { render }
end
