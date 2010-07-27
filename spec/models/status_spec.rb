require 'spec_helper'

describe Status do
  it_should_allow_mass_assignment_only_of :text
  
  it { should belong_to(:project) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:project) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:text) }
end
