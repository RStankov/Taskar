class Task < ActiveRecord::Base
  belongs_to :section
  belongs_to :project
  belongs_to :user
  belongs_to :responsible_party, :class_name => "User"
  
  has_one :event, :as => "subject"
  
  has_many :comments, :dependent => :destroy
  
  validates_presence_of :text, :section, :project, :user
  validates_inclusion_of :status, :in => [-1, 0, 1]
  
  attr_accessor :insert_before
  
  attr_accessible :text, :insert_before, :responsible_party_id
  
  attr_readonly :project_id, :user_id
  
  acts_as_list :scope => :section
  
  include Taskar::List::Model
  
  before_validation_on_create :inherit_section_project 
  
  named_scope :archived,   :conditions => { :archived => true  }, :order => "position DESC"
  named_scope :unarchived, :conditions => { :archived => false }, :order => "position ASC"
  
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
end
