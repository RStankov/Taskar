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

  def set_user_projects(user, project_ids)
    return unless project_ids.is_a? Array

    project_ids = project_ids.find_all { |project_id| projects.exists? project_id }.map &:to_i
    project_users = ProjectUser.joins(:project).where("projects.account_id" => id, "projects.completed" => false, :user_id => user.id)
    project_users.reject! do |project_user|
      if project_ids.include? project_user.project_id
        project_ids.delete(project_user.project_id)
        true
      end
    end
    project_users.map &:destroy

    project_ids.each do |project_id|
      ProjectUser.create(:user_id => user.id, :project_id => project_id)
    end
  end
end
