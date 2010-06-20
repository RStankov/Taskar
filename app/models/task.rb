class Task < ActiveRecord::Base
  belongs_to :section, :touch => true
  has_many :comments, :dependent => :destroy
  
  validates_presence_of :text
  validates_presence_of :section
  validates_inclusion_of :status, :in => [-1, 0, 1]
  
  attr_accessor :insert_before
  
  attr_accessible :text, :insert_before
  
  acts_as_list :scope => :section
  
  default_scope :order => "position ASC"
  
  delegate :project, :to => :section
  
  def add_to_list_bottom
    self[position_column] = if insert_before && record = Task.find(:first, :conditions => {:id => insert_before})
      increment_positions_on_lower_items record.position
      record.position
    else
      bottom_position_in_list.to_i + 1
    end
  end
  
  STATES = {
    -1 => "rejected",
     0 => "opened",
     1 => "completed"
  }
  
  def state
    STATES[status]
  end
  
  def state=(state)
    self.status = STATES.index(state)
  end
  
  def self.reorder(ids)
    if ids.is_a? Array
      position = 0
      ids.each do |id|
        find(id).update_attribute('position', position += 1)
      end
    end
  end
  
  def self.search(ss, limit = 20)
    find :all, :conditions => ["text LIKE :ss", {:ss => "%#{ss}%"}], :limit => limit
  end
end
