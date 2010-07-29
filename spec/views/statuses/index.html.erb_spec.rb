require 'spec_helper'

describe "/statuses/index" do
  before do
    assigns[:statuses] = [Factory(:status)].paginate
  end

  it { render }
end
