class Task < ActiveRecord::Base
  belongs_to :section
  belongs_to :project
  belongs_to :user
  belongs_to :responsible_party, :class_name => "User"
  
  has_one :event, :as => "subject"
  
  has_many :comments, :dependent => :destroy
  
  validates_presence_of :text, :section, :project, :user
  validates_inclusion_of :status, :in => [-1, 0, 1]
    
  attr_accessible :text, :insert_after, :responsible_party_id
  
  attr_readonly :project_id, :user_id
  
  acts_as_list :scope => :section
  
  include Taskar::List::Model
  
  before_validation_on_create :inherit_section_project 
  
  validate_on_create :ensure_section_is_not_archived
  validate_on_update :project_id_on_new_section
  
  named_scope :archived,          :conditions => { :archived => true  }, :order => "position DESC"
  named_scope :unarchived,        :conditions => { :archived => false }, :order => "position ASC"
  named_scope :opened_in_project, lambda { |project| {:conditions => {:project_id => project.id, :status => 0}} }
  
  STATES = {
    -1 => "rejected",
     0 => "opened",
     1 => "completed"
  }
  
  def state
    STATES[status]
  end
  
  def state=(state)
    self.status = STATES.index(state) unless archived?
  end
  
  def self.search(ss, limit = 20)
    find :all, :conditions => ["text LIKE :ss", {:ss => "%#{ss.gsub(' ', '%')}%"}], :limit => limit
  end
  
  def archived=(archived)
    if status != 0 || !archived
      move_to_bottom
      super
    end
  end
  
  def editable?
    status == 0
  end
  
  protected 
    def inherit_section_project
      self.project = section.try(:project)
    end
    
    def ensure_section_is_not_archived
      if section && section.archived?
        errors.add_to_base I18n.t("activerecord.errors.tasks.archived_section") 
      end
    end
    
    def project_id_on_new_section
      if section_id_changed? && section.reload && section.project_id != project_id
        errors.add :section_id, I18n.t("activerecord.errors.tasks.cant_change_project")
      end
    end
end
