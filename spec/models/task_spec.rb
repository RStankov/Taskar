require 'spec_helper'

describe Task do
  it { should allow_mass_assignment_of(:text) }
  it { should_not allow_mass_assignment_of(:status) }
  it { should_not allow_mass_assignment_of(:position) }
  it { should_not allow_mass_assignment_of(:section_id) }
  
  it { should belong_to(:section) }
  
  it { should validate_presence_of(:text) }
  it { should validate_presence_of(:section) }
  
end
