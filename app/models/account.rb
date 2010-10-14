class Account < ActiveRecord::Base
  belongs_to :owner, :class_name => "User"

  validates :name,    :presence => true, :uniqueness => true
  validates :domain,  :presence => true, :uniqueness => true, :format => /^[a-z_0-9]+$/

  attr_accessible :domain, :name
  attr_readonly   :domain

  before_validation :normalize_domain, :on => :create

  has_many :users, :through => :account_users
  has_many :account_users, :dependent => :destroy
  has_many :projects, :dependent => :destroy

  def self.find_id_by_domain(domain)
    if domain.present? && account = where(:domain => domain.downcase).first
      account.id
    end
  end

  protected
    def normalize_domain
      unless domain.blank?
        self.domain = domain.gsub(" ", "_").downcase
      end
    end
end
