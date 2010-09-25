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

  describe "#unseen_events" do
    before do
      @project_user = Factory.build(:project_user)
      @project_user.event_seen!
    end

    def build_events(count, attributes = {})
      (1..count).map { |i| Factory :event, attributes.merge(:project => @project_user.project) }
    end

    def build_unseen_events(count, attributes = {})
      events = build_events(count, attributes)
      Event.update_all(["updated_at = ?", (@project_user.last_seen_event_at || @project_user.created_at) + 5.minutes], ["id IN (?)", events.collect(&:id)])
      events
    end

    it "should select events created after the last user seen" do
      seen_events = build_events 3

      @project_user.event_seen!

      unseen_events = build_unseen_events 2

      @project_user.unseen_events.count.should == 2
      @project_user.unseen_events.should == unseen_events
    end

    it "should not select events created by the current user" do
      user_events = build_unseen_events 3, :user_id => @project_user.user_id

      @project_user.unseen_events.should == []

      unseen_events = build_unseen_events 2

      @project_user.unseen_events.count.should == 2
      @project_user.unseen_events.should == unseen_events
    end

    it "should not cache unseen events" do
      unseen_events = build_unseen_events 2

      @project_user.unseen_events.count.should == 2
      @project_user.unseen_events.should == unseen_events

      @project_user.update_attribute :last_seen_event_at, unseen_events.first.updated_at + 20.minutes

      @project_user.unseen_events.count.should == 0
      @project_user.unseen_events.should == []
    end

    it "should return ActiveRecord::Relation" do
      @project_user.unseen_events.class.should == ActiveRecord::Relation
    end

    it "should work will nil dates" do
      @project_user.last_seen_event_at = nil

      unseen_events = build_unseen_events 2

      @project_user.unseen_events.count.should == 2
      @project_user.unseen_events.should == unseen_events
    end
  end
end
