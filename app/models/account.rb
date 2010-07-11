class Account < ActiveRecord::Base
  belongs_to :owner, :class_name => "User"
  
  validates_presence_of :name
  
  validates_uniqueness_of :name
  
  attr_accessible :name
  
  has_many :users, :dependent => :destroy
end
