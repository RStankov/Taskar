class Status < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  
  has_one :event, :as => "subject", :dependent => :destroy
  
  validates_presence_of :user, :project, :text
  
  attr_accessible :text
end
