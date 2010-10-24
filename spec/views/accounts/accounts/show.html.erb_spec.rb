require 'spec_helper'

describe "/accounts/accounts/show.html.erb" do
  before do
    sign_in Factory(:user)

    assign :account, Factory.stub(:account)
  end

  it "should render events table (if there is atleast one project)" do
    assign :projects, [Factory.stub(:project)]

    render
    rendered.should_not have_selector('.help_notice')
    rendered.should have_selector('#events')
  end

  it "should render .help_notice (if there isn't any project)" do
    assign :projects, []

    render
    rendered.should have_selector('.help_notice')
    rendered.should_not have_selector('#events')
  end
end
