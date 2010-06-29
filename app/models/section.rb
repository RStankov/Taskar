class Section < ActiveRecord::Base
  belongs_to :project
  
  has_many :tasks, :dependent => :destroy
  
  has_one :event, :as => "subject"
  
  validates_presence_of :name
  validates_presence_of :project
  
  attr_accessor :insert_before
  
  attr_accessible :name, :insert_before
  
  attr_readonly :project_id
  
  acts_as_list :scope => :project

  default_scope :order => "position ASC"

  include Taskar::List::Model
end