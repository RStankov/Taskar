class Invitation < ActiveRecord::Base
  belongs_to :account

  validates_presence_of :account, :email, :first_name, :last_name, :token

  validates_uniqueness_of :token
  validates_uniqueness_of :email, :scope => :account_id, :case_sensitive => false
  validates_format_of :email, :with => Devise.email_regexp

  attr_readonly :account_id, :email

  attr_accessible :email, :first_name, :last_name, :message

  before_validation :generate_token, :on => :create

  protected
    def generate_token
      self.token = "[invitation-token-#{Time.now}-#{email}-#{rand(100)}]"
    end
end
