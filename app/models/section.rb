class Section < ActiveRecord::Base
  belongs_to :project
  
  has_many :tasks, :dependent => :destroy
  
  validates_presence_of :name
  validates_presence_of :project
  
  attr_accessor :insert_before
  
  attr_accessible :name, :insert_before
  
  attr_readonly :project_id
  
  acts_as_list :scope => :project

  include Taskar::List::Model
  
  named_scope :archived,   :conditions => { :archived => true  }, :order => "position DESC"
  named_scope :unarchived, :conditions => { :archived => false }, :order => "position ASC"

  def archived=(archived)
    if tasks.unarchived.count == 0
      move_to_bottom
      super(archived ? true : false)
    end
  end
end