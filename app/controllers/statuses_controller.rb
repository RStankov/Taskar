class StatusesController < ApplicationController
  layout "sections"

  before_filter :get_project
  before_filter :check_project_permissions
  
  def create
    @status = current_user.new_status(@project, params[:status])
    
    if @status.save
      activity @status
    end
    
    unless request.xhr?
      redirect_to [@project, :statuses]
    else
      head :ok
    end
  end

  def index
    @statuses = @project.statuses.paginate(:page => params[:page], :per_page => 20, :order => "id DESC")
  end
end
