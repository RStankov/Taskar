class Accounts::InvitationsController < Accounts::BaseController
  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = @account.invitations.build(params[:invitation])

    if @invitation.save
      redirect_to [@account, :users]
    else
      render "new"
    end
  end

  def update

  end

  def destroy
    @invitation = @account.invitations.find(params[:id])
    @invitation.destroy

    redirect_to [@account, :users]
  end

end
