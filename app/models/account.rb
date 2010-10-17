class Account < ActiveRecord::Base
  belongs_to :owner, :class_name => "User"

  validates :name, :presence => true, :uniqueness => true

  attr_accessible :name

  attr_readonly :owner_id

  has_many :users, :through => :account_users
  has_many :account_users, :dependent => :destroy
  has_many :projects, :dependent => :destroy
  has_many :invitations, :dependent => :destroy

  def admin?(user)
    if owner_id == user.id
      true
    else
      account_user = account_users.find_by_user_id(user.id)
      account_user && account_user.admin
    end
  end

  def set_admin_status(user, status)
    if account_user = account_users.find_by_user_id(user.id)
      account_user.update_attribute(:admin, status)
    end
  end
end
