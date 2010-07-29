class StatusesController < ApplicationController
  layout "sections"

  before_filter :get_project
  before_filter :check_project_permissions
  
  def create
    @status = current_user.new_status(@project, params[:status])
    @status.save
    
    unless request.xhr?
      redirect_to [@project, :statuses]
    end
  end

  def index
    @statuses = @project.statuses.paginate(:page => params[:page], :per_page => 30)
  end

  private
    def get_project
      @project = Project.find(params[:project_id])
    end
end
