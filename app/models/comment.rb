class Comment < ActiveRecord::Base
  belongs_to :user, :counter_cache => true, :touch => :last_active_at
  belongs_to :task, :counter_cache => true
  belongs_to :project
  
  has_one :event, :as => "subject"
  
  validates_presence_of :text, :user, :task, :project
  
  before_validation_on_create :inherit_task_project 
  
  attr_accessible :text
  
  attr_readonly :project_id
  
  EDITABLE_BY = 15.minutes
  
  def editable_by? user
    self.user_id == user.id && updated_at + EDITABLE_BY > Time.now
  end
  
  def editable_for
    if updated_at + EDITABLE_BY > Time.now
      (((updated_at + EDITABLE_BY) - Time.now) / 60).ceil
    else
      0
    end
  end
  
  protected
    def inherit_task_project
      self.project = task.try(:project)
    end
end
