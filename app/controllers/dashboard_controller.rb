class DashboardController < ApplicationController
  def index
    @projects = current_user.projects.active.order(:account_id)

    if @projects.size == 1 && !current_user.admin?
      redirect_to [@projects.first, :sections]
    end
  end
end
