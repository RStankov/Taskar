class User < ActiveRecord::Base
  include Taskar::Auth::Model

  attr_accessible             :email, :password, :password_confirmation, :first_name, :last_name, :avatar, :owned_account_attributes, :remember_me, :locale

  validates_presence_of       :first_name, :last_name, :account
  validates_inclusion_of      :locale, :in => %w(bg en), :allow_blank => true

  has_attached_file           :avatar,  :styles => { :image => '48x48', :aside => '32x32' }, :default_style => :image

  has_many :events, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :statuses, :dependent => :destroy

  has_many :responsibilities, :class_name => "Task", :foreign_key => "responsible_party_id"

  has_many :project_participations, :class_name => "ProjectUser", :foreign_key => "user_id", :dependent => :destroy
  has_many :projects, :through => :project_participations

  has_one :owned_account, :class_name => "Account", :foreign_key => "owner_id" # deprecated

  has_many :owned_accounts, :class_name => "Account", :foreign_key => "owner_id"

  belongs_to :account

  attr_readonly :account_id

  accepts_nested_attributes_for :owned_account, :reject_if => :cant_assign_own_account

  before_validation :assign_own_account, :on => :create
  after_create :assign_as_account_owner

  def full_name
    @full_name ||= "#{first_name} #{last_name}"
  end

  def short_name
    @short_name ||= "#{first_name} #{last_name[0,1]}."
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

  def admin= value
    if value || !owned_account
      super(value)
    end
  end

  private
    def cant_assign_own_account
      !new_record?
    end

    def assign_own_account
      if owned_account
        if account
          self.owned_account = nil
        else
          self.account = owned_account
          self.admin   = true
        end
      end
    end

    def assign_as_account_owner
      if owned_account
        owned_account.owner = self
        owned_account.save
      end
    end
end
