class Task < ActiveRecord::Base
  belongs_to :section
  belongs_to :project
  belongs_to :user
  belongs_to :responsible_party, :class_name => "User"

  has_one :event, :as => "subject"

  has_many :comments, :dependent => :destroy

  validates_presence_of :text, :section, :project, :user
  validates_inclusion_of :status, :in => [-1, 0, 1]

  attr_accessible :text, :insert_after, :responsible_party_id

  attr_readonly :project_id, :user_id

  acts_as_list :scope => :section

  include Taskar::List::Model

  before_validation :inherit_section_project, :on => :create

  validate :ensure_section_is_not_archived, :on => :create
  validate :project_id_on_new_section, :on => :update

  scope :archived,          where(:archived => true  ).order("position DESC")
  scope :unarchived,        where(:archived => false ).order("position ASC")
  scope :rejected,          where(:status => -1)
  scope :opened,            where(:status =>  0)
  scope :completed,         where(:status =>  1)
  scope :opened_in_project, lambda { |project| where(:project_id => project.id, :status => 0) }
  scope :search,            lambda { |ss|      where("text LIKE ?", "%#{ss.gsub(' ', '%')}%") }

  STATES = {
    -1 => "rejected",
     0 => "opened",
     1 => "completed"
  }

  def state
    STATES[status]
  end

  def state=(state)
    self.status = STATES.index(state) unless archived?
  end

  def archived=(archived)
    if status != 0 || !archived
      move_to_bottom
      super
    end
  end

  def editable?
    status == 0
  end

  def toggle_archived
    update_attribute :archived, !archived
  end

  protected
    def inherit_section_project
      self.project = section.try(:project)
    end

    def ensure_section_is_not_archived
      if section && section.archived?
        errors[:base] = I18n.t("activerecord.errors.tasks.archived_section")
      end
    end

    def project_id_on_new_section
      if section_id_changed? && section.reload && section.project_id != project_id
        errors.add :section_id, I18n.t("activerecord.errors.tasks.cant_change_project")
      end
    end
end
