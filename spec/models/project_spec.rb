require 'spec_helper'

describe Project do
  it { should validate_presence_of(:name) }
  it { should have_many(:sections) }
  it { should have_many(:participants) }
  it { should have_many(:users) }
end
