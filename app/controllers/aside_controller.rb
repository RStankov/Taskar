class AsideController < ApplicationController
  before_filter :get_project, :only => :index
  before_filter :check_project_permissions
  
  
  def index
    count = current_user.responsibilities_count(@project.id)
    render :json => {
      :responsibilities_count => t(:'layouts.sections.tasks', :count => count)
    }
  end
  
  private
    def get_project
      @project = Project.find(params[:project_id])
    end
end
