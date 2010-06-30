class Comment < ActiveRecord::Base
  belongs_to :user, :counter_cache => true
  belongs_to :task, :counter_cache => true
  belongs_to :project
  
  has_one :event, :as => "subject"
  
  validates_presence_of :text, :user, :task, :project
  
  before_validation_on_create :inherit_task_project 
  
  validate :ensure_task_is_not_archived, :if => :new_record?
  
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
    
    def ensure_task_is_not_archived
      errors.add_to_base(I18n.t('activerecord.errors.comment.archived_task')) if task && task.archived?
    end
end
