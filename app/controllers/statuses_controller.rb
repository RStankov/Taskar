class StatusesController < ApplicationController
  layout "sections"

  before_filter :get_project
  before_filter :check_project_permissions
  
  def create
  end

  def index
    @statuses = @project.statuses.paginate(:page => params[:page], :per_page => 30)
  end

  private
    def get_project
      @project = Project.find(params[:project_id])
    end
end
