class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :subject, :polymorphic => true
  
  attr_readonly :project_id, :user_id
  
  validates_presence_of :user, :project, :action
  
  before_validation_on_create :inherit_subject_project
  
  protected
    def inherit_subject_project
      self.project_id = subject.try(:project_id)
    end
end
