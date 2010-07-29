require 'spec_helper'

describe "/statuses/index" do
  before do
    assigns[:statuses] = [Factory(:status)].paginate
    assigns[:project] = mock_project
  end

  it { render }
end
