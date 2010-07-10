class Project < ActiveRecord::Base
  has_many :events, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :sections, :dependent => :destroy
  has_many :participants, :class_name => "ProjectUser", :foreign_key => "project_id", :dependent => :destroy
  
  has_many :users, :through => :participants
  
  validates_presence_of     :name
  validates_uniqueness_of   :name, :case_sensitive => false
  
  attr_accessible :name, :user_ids
  
  named_scope :active,    :conditions => { :completed => false  }
  named_scope :completed, :conditions => { :completed => true   }
  
  def involves?(user)
    users.include? user
  end
end
