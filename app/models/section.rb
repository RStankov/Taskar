class Section < ActiveRecord::Base
  belongs_to :project
  
  validates_presence_of :name
  validates_presence_of :project
  
  attr_accessible :name
  
  attr_readonly :project_id
end
