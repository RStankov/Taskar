class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :subject, :polymorphic => true
  
  attr_readonly :project_id, :user_id
  attr_accessible :action, :subject
  
  default_scope :order => 'updated_at DESC'
  
  validates_presence_of :user, :project, :action, :subject_id, :subject_type
  
  before_validation_on_create :inherit_subject_project
  
  before_save :set_info
  
  protected
    def inherit_subject_project
      self.project_id = subject.try(:project_id)
    end
    
    def set_info
      self.info = case subject_type
        when "Section"  then subject.name
        when "Task"     then subject.text
        when "Comment"  then subject.task.text
      end
    end
end
