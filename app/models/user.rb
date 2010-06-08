class User < ActiveRecord::Base
  include Taskar::Auth::Model
  
  attr_accessible             :email, :password, :password_confirmation, :first_name, :last_name

  validates_presence_of       :first_name
  validates_presence_of       :last_name
  
  def full_name
    @full_name ||= "#{first_name} #{last_name}"
  end
end
