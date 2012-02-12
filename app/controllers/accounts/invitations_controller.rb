class Accounts::InvitationsController < Accounts::BaseController
  def index
  end

  def new
    @invitation = Invitation.new

    render :layout => 'members'
  end

  def create
    @invitation = @account.invitations.build(params[:invitation])

    if @invitation.save
      @invitation.send_invite

      redirect_to account_members_path(@account), :notice => 'Invitation send successfully'
    else
      render 'new', :layout => 'members'
    end
  end

  def update
    invitation = find_invitation
    invitation.send_invite

    redirect_to account_invitations_path(@account), :notice => 'Invitation resend successfully'
  end

  def destroy
    invitation = find_invitation
    invitation.destroy

    redirect_to account_invitations_path(@account)
  end

  private

  def find_invitation
    @account.invitations.find(params[:id])
  end
end
