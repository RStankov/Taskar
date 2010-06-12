class Section < ActiveRecord::Base
  belongs_to :project
  
  validates_presence_of :name
  validates_presence_of :project
  
  attr_accessible :name
  
  attr_readonly :project_id
  
  acts_as_list :scope => :project
  
  default_scope :order => "position ASC"

  def move_to(position)
    case position.to_s
      when "top"    then  move_to_top
      when "bottom" then  move_to_bottom
      else                insert_at(Section.find(position).position)
    end
  end
end
