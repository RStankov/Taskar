class AsideController < ApplicationController
  before_filter :get_project, :only => :index
  before_filter :check_project_permissions
  
  def index
    @responsibilities_count = current_user.responsibilities_count(@project.id)
    @unseen_events_count    = project_user.unseen_events.count
    @participants           = @project.participants
  end
  
  private
    def get_project
      @project = Project.find(params[:project_id])
    end
end
