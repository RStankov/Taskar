class DashboardController < ApplicationController
  def index    
    @projects = current_user.projects.active
  end
end
