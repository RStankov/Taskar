class Comment < ActiveRecord::Base
  belongs_to :task, :counter_cache => true
  belongs_to :user, :counter_cache => true
  
  validates_presence_of :text
  
  attr_accessible :text
end
