class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :subject, :polymorphic => true
  
  attr_readonly :project_id, :user_id
  attr_accessible :action, :subject
  
  validates_presence_of :user, :project, :action, :subject_id, :subject_type
  
  before_validation_on_create :inherit_subject_project
  
  default_scope :order => 'updated_at DESC'
  
  protected
    def inherit_subject_project
      self.project_id = subject.try(:project_id)
    end
end
