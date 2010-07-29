class Status < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  
  has_one :event, :as => "subject", :dependent => :destroy
  
  validates_presence_of :user, :project, :text
  
  attr_accessible :text
  
  after_create :update_project_user_status
  
  private
    def update_project_user_status
      if project_user = ProjectUser.first(:conditions => {:user_id => user_id, :project_id => project_id})
        project_user.update_attribute :status, text
      end
    end
end
