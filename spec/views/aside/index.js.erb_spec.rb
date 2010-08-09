require 'spec_helper'

describe "/aside/index.js.erb" do
  before do
    assigns[:responsibilities_count]  = 1234
    assigns[:participants] = []
  end

  it { render }
end
