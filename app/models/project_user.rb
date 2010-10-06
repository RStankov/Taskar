class ProjectUser < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  validates_presence_of :project, :user
  validates_uniqueness_of :user_id, :scope => :project_id

  attr_accessible :user_id

  attr_readonly :project_id, :user_id

  def event_seen!
    update_attribute :last_seen_event_at, current_time_from_proper_timezone
  end

  def unseen_events
    Event.unseen_from self
  end
end
