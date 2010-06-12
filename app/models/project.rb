class Project < ActiveRecord::Base
  has_many :sections, :dependent => :destroy
  validates_presence_of :name
end
