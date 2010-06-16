class User < ActiveRecord::Base
  include Taskar::Auth::Model
  
  attr_accessible             :email, :password, :password_confirmation, :first_name, :last_name, :avatar

  validates_presence_of       :first_name
  validates_presence_of       :last_name
  
  has_attached_file           :avatar,  :styles => { :image => '48x48', :aside => '32x32' }, :default_style => :image
  
  has_many :comments, :dependent => :destroy
  
  def full_name
    @full_name ||= "#{first_name} #{last_name}"
  end
  
  def new_comment(task)
    task.comments.build do |comment|
      comment.user_id = id
    end
  end
end
