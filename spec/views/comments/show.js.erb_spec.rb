require 'spec_helper'

describe "/comments/show.js.erb" do
  before do
    sign_in Factory(:user)

    assign :comment, Factory(:comment)
  end

  it { render }
end