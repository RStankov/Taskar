class Section < ActiveRecord::Base
  belongs_to :project
  
  validates_presence_of :name
  validates_presence_of :project
  
  attr_accessor :insert_before
  
  attr_accessible :name, :insert_before
  
  attr_readonly :project_id
  
  acts_as_list :scope => :project
  
  default_scope :order => "position ASC"

  def move_before(record_id)
    if record_id && record = Section.find(:first, :conditions => {:id => record_id})
      insert_at(record.position)
    end
  end
  
  def add_to_list_bottom
    self[position_column] = if insert_before && record = Section.find(:first, :conditions => {:id => insert_before})
      increment_positions_on_lower_items record.position
      record.position
    else
      bottom_position_in_list.to_i + 1
    end
  end
end