require 'spec_helper'

describe "/dashboard/index" do
  before do
    sign_in Factory(:user)
  end

  it "should render empty dashboard message" do
    assign :projects, []

    render

    rendered.should have_selector('.help_notice')
    rendered.should_not have_selector('#events')
  end

  it "should render events table if projects exists" do
    assign :projects, [ Factory(:project) ]

    render

    rendered.should_not have_selector('.help_notice')
    rendered.should have_selector('#events')
  end
end
