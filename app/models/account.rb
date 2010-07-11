class Account < ActiveRecord::Base
  belongs_to :owner, :class_name => "User"
  
  validates_presence_of :name, :owner
  
  validates_uniqueness_of :name
  validates_uniqueness_of :owner_id
  
  attr_accessible :name
  attr_readonly   :name, :owner_id
end
