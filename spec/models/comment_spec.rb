require 'spec_helper'

describe Comment do
  it { should validate_presence_of(:text) }
  it { should belong_to(:user) }
  it { should belong_to(:task) }
  
  it { should_not allow_mass_assignment_of(:user_id) }
  it { should_not allow_mass_assignment_of(:task_id) }
  it { should     allow_mass_assignment_of(:text) }
end
