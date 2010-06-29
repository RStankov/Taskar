class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :subject, :polymorphic => true
  
  validates_presence_of :user, :project, :action
end
