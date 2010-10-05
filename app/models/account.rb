class Account < ActiveRecord::Base
  belongs_to :owner, :class_name => "User"

  validates_presence_of :name

  validates_uniqueness_of :name

  attr_accessible :name

  has_many :users,    :dependent => :destroy
  has_many :projects, :dependent => :destroy

  def self.find_id_by_name(name)
    if name && account = where(:name => name).first
      account.id
    end
  end
end
