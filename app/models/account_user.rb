class AccountUser < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  belongs_to :account
  belongs_to :user

  validates_presence_of :account, :user
  validates_uniqueness_of :user_id, :scope => :account_id

  attr_accessible :user_id

  attr_readonly :project_id, :user_id

  def admin?
    admin || (account && account.owner_id == user_id)
  end

  memoize :admin?
end
