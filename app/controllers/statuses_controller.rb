class StatusesController < ApplicationController
  layout "sections"

  before_filter :get_project
  before_filter :check_project_permissions
  
  def create
  end

  def index
  end

  private
    def get_project
      @project = Project.find(params[:project_id])
    end
end
