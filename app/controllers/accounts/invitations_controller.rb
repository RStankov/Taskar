class Accounts::InvitationsController < Accounts::BaseController
  def index
  end

  def new
    @invitation = Invitation.new

    render :layout => 'users'
  end

  def create
    @invitation = @account.invitations.build(params[:invitation])

    if @invitation.save
      @invitation.send_invite

      redirect_to [@account, :users]
    else
      render 'new', :layout => 'users'
    end
  end

  def update
    find_invitation.send_invite

    redirect_to [@account, :users], :notice => 'Invitation resend successfully'
  end

  def destroy
    find_invitation.destroy

    redirect_to [@account, :users]
  end


  private

  def find_invitation
    @account.invitations.find(params[:id])
  end
end
