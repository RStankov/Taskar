class Sign::InvitationsController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :set_locale

  before_filter :get_invitation

  def show
  end

  def update
    if process_user(params[:user])
      sign_in @invitation.user
      redirect_to :root, :notice => t("devise.invitations.complete")
    else
      render :action => "show"
    end
  end

  def destroy
    render :action => "show"
  end

  protected
    def get_invitation
      unless @invitation = Invitation.find_by_token(params[:id])
        render "not_found", :status => 404
      end
    end

    def process_user(params)
      if @invitation.user.new_record?
        @invitation.create_user(params)
      else
        @invitation.user.valid_password? params[:password]
      end
    end

    def controller_path
      "devise/invitations"
    end
end