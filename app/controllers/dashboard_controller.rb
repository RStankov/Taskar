class DashboardController < ApplicationController
  def index
    @projects = current_user.projects.active.limit(5)
  end
end
