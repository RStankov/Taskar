class Section < ActiveRecord::Base
  belongs_to :project

  has_many :tasks, :dependent => :destroy

  validates_presence_of :name
  validates_presence_of :project

  attr_accessible :name, :text, :insert_before

  attr_readonly :project_id

  acts_as_list :scope => :project

  include Taskar::List::Model

  scope :archived,   where(:archived => true).order("position DESC")
  scope :unarchived, where(:archived => false).order("position ASC")

  def archived=(archived)
    if tasks.unarchived.count == 0
      move_to_bottom
      super(archived ? true : false)
    end
  end

  def current_tasks
    if archived?
      tasks.archived
    else
      tasks.unarchived
    end
  end
end