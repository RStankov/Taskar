class Sign::InvitationsController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :set_locale

  def show
  end

  def update
    render :action => "show"
  end

  def destroy
    render :action => "show"
  end

  protected
    def controller_path
      "devise/invitations"
    end
end
