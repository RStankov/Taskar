class Account < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User'

  validates :name, :presence => true, :uniqueness => true

  attr_accessible :name

  attr_readonly :owner_id

  has_many :users, :through => :account_users
  has_many :account_users, :dependent => :destroy
  has_many :projects, :dependent => :destroy
  has_many :invitations, :dependent => :destroy
end
