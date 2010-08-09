require 'spec_helper'

describe ProjectUser do
  it_should_allow_mass_assignment_only_of :user_id
  
  it { should belong_to(:user) }
  it { should belong_to(:project) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:project) }
  it { Factory(:project_user).should validate_uniqueness_of(:user_id).scoped_to(:project_id) }
  
  describe "#event_seen!" do
    it "should last_seen_event_at column with current time" do
      user = Factory.build :project_user
      user.last_seen_event_at.try(:time).to_s.should_not == user.send(:current_time_from_proper_timezone).to_s
      user.event_seen!
      user.reload.last_seen_event_at.time.to_s.should == user.send(:current_time_from_proper_timezone).to_s
    end
  end
end
