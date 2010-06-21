require 'spec_helper'

describe Project do
  it_should_allow_mass_assignment_only_of :name, :user_ids
  
  it { should validate_presence_of(:name) }
  it { should have_many(:sections) }
  it { should have_many(:participants) }
  it { should have_many(:users) }
end
