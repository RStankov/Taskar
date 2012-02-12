require 'delegate'

class AccountMember
  class << self
    def find(account, user_id)
      new account.users.find(user_id), account
    end

    def for(account)
      wrap account, account.users
    end

    def wrap(account, users)
      users.map { |user| new user, account}
    end
  end

  delegate :id, :email, :first_name, :last_name, :full_name, :avatar, :project_ids, :to_param, :to => :user

  attr_reader :user, :account

  alias :to_model :user

  def initialize(user, account)
    @user = user
    @account = account
  end

  def ==(other)
    if other.kind_of? AccountMember
      user == other.user
    else
      user == other
    end
  end

  def owner?
    user.id == account.owner_id
  end

  def admin?
    owner? or account_user.admin?
  end

  def removable?
    not admin?
  end

  def remove
    return false if admin?

    account_user.destroy
    project_users.map &:destroy

    true
  end

  def set_admin_status_to(status)
    account_user.update_attributes! :admin => status
  end

  def set_projects(project_ids)
    project_ids = Project.where(:id => project_ids, :account_id => account.id).map &:id

    project_users_for_deletion = project_users.where('projects.completed' => false).reject do |project_user|
      if project_ids.include? project_user.project_id
        project_ids.delete(project_user.project_id)
        true
      end
    end
    project_users_for_deletion.map &:destroy

    project_ids.each do |project_id|
      ProjectUser.create(:user_id => user.id, :project_id => project_id)
    end
  end

  private

  def account_user
    @account_user ||= AccountUser.where(:user_id => user.id, :account_id => account.id).first
  end

  def project_users
    ProjectUser.joins(:project).where('projects.account_id' => account.id, 'user_id' => user.id)
  end
end