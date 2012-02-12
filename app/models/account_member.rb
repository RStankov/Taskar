require 'delegate'

class AccountMember
  class << self
    def find(account, user_id)
      new account.users.find(user_id), account
    end
  end

  delegate :email, :first_name, :last_name, :full_name, :avatar, :project_ids, :to => :user

  attr_reader :user, :account

  alias :to_model :user

  def initialize(user, account)
    @user = user
    @account = account
  end

  def owner?
    user.id == account.owner_id
  end

  def admin?
    owner? or account_user.admin?
  end

  private

  def account_user
    @account_user ||= AccountUser.where(:user_id => user.id, :account_id => account.id).first
  end
end