class Project < ActiveRecord::Base
  has_many :events, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :sections, :dependent => :destroy
  has_many :participants, :class_name => "ProjectUser", :foreign_key => "project_id", :dependent => :destroy
  
  has_many :users, :through => :participants
  
  belongs_to :account
  
  validates_presence_of     :name, :account
  validates_uniqueness_of   :name, :scope => :account_id, :case_sensitive => false
  
  attr_accessible :name, :user_ids
  attr_readonly :account_id
  
  named_scope :active,    :conditions => { :completed => false  }
  named_scope :completed, :conditions => { :completed => true   }
  
  def involves?(user)
    users.include? user
  end
end
