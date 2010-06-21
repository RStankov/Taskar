require 'spec_helper'

describe ProjectUser do
  it_should_allow_mass_assignment_only_of :user_id
  
  it { should belong_to(:user) }
  it { should belong_to(:project) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:project) }
  it { Factory(:project_user).should validate_uniqueness_of(:user_id).scoped_to(:project_id) }
end
