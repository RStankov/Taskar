class Project < ActiveRecord::Base
  has_many :sections, :dependent => :destroy
  has_many :participants, :class_name => "ProjectUser", :foreign_key => "project_id", :dependent => :destroy
  has_many :users, :through => :participants
  
  validates_presence_of :name
  
  attr_accessible :name, :user_ids
end
