class StatusesController < ApplicationController
  layout "sections"

  before_filter :get_project
  before_filter :check_project_permissions
  
  def create
    @status = current_user.new_status(@project, params[:status])
    
    if @status.save
      activity @status
    end
    
    redirect_or_head_ok
  end

  def index
    @statuses = @project.statuses.paginate(:page => params[:page], :per_page => 20, :order => "id DESC")
  end
  
  def clear 
    project_user.update_attribute :status, ""
    
    redirect_or_head_ok
  end
  
  private
    def redirect_or_head_ok
      unless request.xhr?
        redirect_to [@project, :statuses]
      else
        head :ok
      end
    end
end
