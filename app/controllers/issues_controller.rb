class IssuesController < ApplicationController
  def create
    current_user.issues.create(params[:issue])

    if request.xhr?
      head :ok
    else
      redirect_to root_path
    end
  end
end
