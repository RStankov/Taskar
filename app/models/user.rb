class User < ActiveRecord::Base
  include Taskar::Auth::Model
  
  attr_accessible             :email, :password, :password_confirmation, :first_name, :last_name, :avatar

  validates_presence_of       :first_name
  validates_presence_of       :last_name
  
  has_attached_file           :avatar,  :styles => { :image => '48x48', :aside => '32x32' }, :default_style => :image
  
  has_many :comments, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :responsibilities, :class_name => "Task", :foreign_key => "responsible_party_id"
  
  has_many :project_participations, :class_name => "ProjectUser", :foreign_key => "user_id", :dependent => :destroy
  has_many :projects, :through => :project_participations
  
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
  
  def responsibilities_count
    @responsibilities_count ||= responsibilities.count :conditions => {:status => 0}
  end
end
