class Account < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User'

  validates :name, :presence => true, :uniqueness => true

  attr_accessible :name

  attr_readonly :owner_id

  has_many :users, :through => :account_users
  has_many :account_users, :dependent => :destroy
  has_many :projects, :dependent => :destroy
  has_many :invitations, :dependent => :destroy

  def owner?(user)
    owner_id == user.id
  end

  def admin?(user)
    if owner? user
      true
    else
      account_user = account_users.find_by_user_id(user.id)
      account_user && account_user.admin
    end
  end
end
