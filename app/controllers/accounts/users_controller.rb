class Accounts::UsersController < Accounts::BaseController
  before_filter :get_user, :only => [:show, :destroy, :set_admin]

  def index
    @users = @account.users
    @invitations = @account.invitations
  end

  def show
  end

  def destroy
    @user.destroy

    redirect_to [@account, :users]
  end

  def set_admin
    unless @user == current_user
      @account.set_admin_status(@user, params[:admin])
    end

    redirect_to [@account, @user]
  end

  private
    def get_user
      @user = @account.users.find(params[:id])
    end
end
