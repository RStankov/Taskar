require "digest/sha1"

class Invitation < ActiveRecord::Base
  belongs_to :account

  validates_presence_of :account, :email, :first_name, :last_name, :token

  validates_uniqueness_of :token
  validates_uniqueness_of :email, :scope => :account_id, :case_sensitive => false
  validates_format_of :email, :with => Devise.email_regexp

  attr_readonly :account_id, :email

  attr_accessible :email, :first_name, :last_name, :message

  before_validation :check_for_duplicate_account_user, :generate_token, :on => :create

  def full_name
    @full_name ||= "#{first_name} #{last_name}"
  end

  def user
    @user ||= User.find_by_email(email) || User.new do |user|
      user.first_name = first_name
      user.last_name  = last_name
    end
  end

  protected
    def check_for_duplicate_account_user
      if account && account.users.find_by_email(email.to_s.downcase)
        errors[:email] << I18n.t("activerecord.errors.invitations.account_exists")
      end
    end

    def generate_token
      self.token = Digest::SHA1.hexdigest("[invitation-token-#{Time.now}-#{email}-#{rand(100)}]")
    end
end
