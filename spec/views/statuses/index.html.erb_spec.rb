require 'spec_helper'

describe "/statuses/index" do
  before do
    sign_in Factory(:user)

    assign :statuses, [Factory(:status)].paginate
    assign :project,  mock_project
  end

  it { render }
end
