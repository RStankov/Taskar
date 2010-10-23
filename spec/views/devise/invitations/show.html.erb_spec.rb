require 'spec_helper'

describe "devise/invitations/show.html.erb" do
  before do
    assign :invitation, @invitation = Factory.stub(:invitation, {
      :token   => "foo",
      :account => Factory.stub(:account, :owner => Factory.stub(:user))
    })
    @invitation.stub(:user).and_return Factory.stub(:user)
  end

  it "should render new user form if invitation.user is new" do
    @invitation.user.stub(:new_record?).and_return true

    render
    rendered.should have_selector("#user_password")
    rendered.should have_selector("#user_password_confirmation")
    rendered.should have_selector("#user_locale")
    rendered.should have_selector("#user_avatar")
  end

  it "should render sign_in form if invitation.user is not new" do
    @invitation.user.stub(:new_record?).and_return false

    render
    rendered.should have_selector("#user_password")
    rendered.should_not have_selector("#user_password_confirmation")
    rendered.should_not have_selector("#user_locale")
    rendered.should_not have_selector("#user_avatar")
  end
end
