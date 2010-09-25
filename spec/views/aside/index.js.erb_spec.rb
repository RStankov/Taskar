require 'spec_helper'

describe "/aside/index.js.erb" do
  before do
    assign :responsibilities_count, 1234
    assign :participants, []
  end

  it { render }
end
