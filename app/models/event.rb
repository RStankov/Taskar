class Event < ActiveRecord::Base
  belongs_to :user, :touch => :last_active_at
  belongs_to :project
  belongs_to :subject, :polymorphic => true
  
  attr_readonly :project_id
  attr_accessible :user, :subject
  
  default_scope :order => 'updated_at DESC'
  
  validates_presence_of :user, :project, :action, :subject_id, :subject_type
  
  before_validation_on_create :inherit_subject_project
  
  before_validation :set_info, :set_action
  
  def self.activity(user, subject)
    if event = find(:first, :conditions => {:subject_id => subject.id, :subject_type => subject.class.name})
      # forces the record to be save, it's timestamp to be updated
      event.updated_at = Time.now
      event.update_attributes(:user => user, :subject => subject)
      event
    else
      create(:user => user, :subject => subject)
    end
  end
  
  def type
    @type ||= subject_type.downcase
  end
  
  def url_options
    {:controller => type.pluralize, :action => :show, :id => subject_id}
  end
  
  def linkable?
    action != "deleted"
  end
  
  protected
    def inherit_subject_project
      self.project_id = subject.try(:project_id)
    end
    
    def set_info
      self.info = case subject_type
        when "Task"     then subject.try(:text) || ""
        when "Comment"  then subject.try(:task).try(:text) || ""
      end
    end
    
    def set_action
      if subject
        self.action = subject.destroyed? ? "deleted" : case subject_type
          when "Comment" then "commented"
          when "Task"    then subject.archived? ? "archived" : subject.state
        end
      end
    end
end
