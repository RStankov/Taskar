class Section < ActiveRecord::Base
  belongs_to :project
  
  validates_presence_of :name
  validates_presence_of :project
  
  attr_accessible :name
  
  attr_readonly :project_id
  
  acts_as_list :scope => :project
  
  default_scope :order => "position ASC"

  def move_before(position)
    position = Section.find(position).position - 1
    insert_at(position < 1 ? 0 : position)
    end
  end
end
