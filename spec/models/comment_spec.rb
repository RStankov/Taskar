require 'spec_helper'

describe Comment do
  it_should_allow_mass_assignment_only_of :text
  
  it { should validate_presence_of(:text) }
  it { should belong_to(:user) }
  it { should belong_to(:task) }
end
