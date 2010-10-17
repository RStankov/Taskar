class DashboardController < ApplicationController
  def index
    @projects = current_user.projects.active.order(:account_id)
  end
end
