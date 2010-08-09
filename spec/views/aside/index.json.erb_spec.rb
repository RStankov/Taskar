require 'spec_helper'

describe "/aside/index.json.erb" do
  before do
    assigns[:responsibilities_count]  = 1234
  end

  it { render }
end
