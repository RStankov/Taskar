require 'spec_helper'

describe Section do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:project) }
  it { should belong_to(:project) }
end
