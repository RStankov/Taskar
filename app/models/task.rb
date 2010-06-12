class Task < ActiveRecord::Base
  belongs_to :section, :touch => true
  
  validates_presence_of :text
  validates_presence_of :section
  validates_inclusion_of :status, :in => [-1, 0, 0]
  
  attr_accessible :text
  
end
