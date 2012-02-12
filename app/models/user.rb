class User < ActiveRecord::Base
  attr_accessible             :email, :password, :password_confirmation, :first_name, :last_name, :avatar, :owned_account_attributes, :remember_me

  validates_presence_of       :first_name, :last_name

  has_attached_file           :avatar,  :styles => { :image => '48x48', :aside => '32x32' }, :default_style => :image

  has_many :events, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :statuses, :dependent => :destroy
  has_many :issues

  has_many :responsibilities, :class_name => "Task", :foreign_key => "responsible_party_id"

  has_many :project_participations, :class_name => "ProjectUser", :foreign_key => "user_id", :dependent => :destroy
  has_many :projects, :through => :project_participations

  has_many :owned_accounts, :class_name => "Account", :foreign_key => "owner_id", :dependent => :destroy

  has_many :account_users, :dependent => :destroy
  has_many :accounts, :through => :account_users

  devise   :database_authenticatable, :lockable, :recoverable, :rememberable, :trackable, :validatable, :registerable

  # deprecated
  has_one :owned_account, :class_name => "Account", :foreign_key => "owner_id"

  accepts_nested_attributes_for :owned_account, :reject_if => :cant_assign_own_account

  before_save  :downcase_email
  after_create :assign_as_account_owner

  def full_name
    @full_name ||= "#{first_name} #{last_name}"
  end

  def new_comment(task, attributes = {})
    task.comments.build(attributes) do |comment|
      comment.user_id = id
    end
  end

  def new_task(section, attributes = {})
    section.tasks.build(attributes) do |task|
      task.user_id = id
    end
  end

  def new_status(project, attributes = {})
    project.statuses.build(attributes) do |status|
      status.user_id = id
    end
  end

  def responsibilities_count(project_id)
    @responsibilities_count ||= {}
    @responsibilities_count[project_id] ||= responsibilities.count :conditions => {:status => 0, :project_id => project_id}
  end

  def self.find_for_authentication(conditions)
    conditions[:email].downcase! if conditions[:email]
    super(conditions)
  end

  def find_account(account_id)
    accounts.find(account_id)
  end

  private
    def downcase_email
      self.email = email.to_s.downcase
    end

    def password_required?
      !persisted? || password.present? || password_confirmation.present?
    end

    def cant_assign_own_account
      !new_record?
    end

    def assign_as_account_owner
      if owned_account
        owned_account.owner = self
        owned_account.save

        account_users.create(:account => owned_account, :admin => true)
      end
    end
end
