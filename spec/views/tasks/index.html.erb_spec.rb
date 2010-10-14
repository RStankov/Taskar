require 'spec_helper'

describe "/tasks/index.html.erb" do
  before do
    sign_in @user = Factory(:user)

    assign :tasks, [ Factory(:task) ]
  end

  it { render }
end
