class Status < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  
  validates_presence_of :user, :project, :content
  
  attr_accessible :content
end
