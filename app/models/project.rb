class Project < ActiveRecord::Base
  has_many :events, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :sections, :dependent => :destroy
  has_many :statuses, :dependent => :destroy
  has_many :participants, :class_name => "ProjectUser", :foreign_key => "project_id", :dependent => :destroy, :include => :user

  has_many :users, :through => :participants

  belongs_to :account

  validates_presence_of     :name, :account
  validates_uniqueness_of   :name, :scope => :account_id, :case_sensitive => false

  attr_accessible :name, :user_ids
  attr_readonly :account_id

  before_save :validate_user_ids

  scope :active,    where(:completed => false).order("updated_at DESC")
  scope :completed, where(:completed => true).order("updated_at DESC")

  # deprecate
  def involves?(user)
    users.include? user
  end

  private
    def validate_user_ids
      if user_ids.size > 0
        self.user_ids = user_ids.find_all { |user_id| account.users.exists? user_id }
      end
    end
end
