class Account < ActiveRecord::Base
  belongs_to :owner, :class_name => "User"

  validates_presence_of :name, :domain
  validates_uniqueness_of :name, :domain

  validates :name,    :presence => true, :uniqueness => true
  validates :domain,  :presence => true, :uniqueness => true, :format => /^[a-z_0-9]+$/

  attr_accessible :domain, :name
  attr_readonly   :domain

  before_validation :normalize_domain, :on => :create

  has_many :users,    :dependent => :destroy
  has_many :projects, :dependent => :destroy

  def self.find_id_by_name(name)
    if name && account = where(:name => name).first
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
