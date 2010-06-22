class DashboardController < ApplicationController
  def index
    current_user.touch(:last_active_at)
    
    @projects = current_user.projects
  end
end
