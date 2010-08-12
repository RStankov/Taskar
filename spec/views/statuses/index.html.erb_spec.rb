require 'spec_helper'

describe "/statuses/index" do
  before do
    sign_in Factory(:user) 
        
    assigns[:statuses] = [Factory(:status)].paginate
    assigns[:project] = mock_project
  end

  it { render }
end
