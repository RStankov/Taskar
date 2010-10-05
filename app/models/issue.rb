class Issue < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id, :description

  attr_accessible :url, :description
end
