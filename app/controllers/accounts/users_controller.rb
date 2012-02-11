class Accounts::UsersController < Accounts::BaseController
  layout 'users'

  before_filter :get_user, :only => [:show, :destroy, :set_admin, :set_projects]

  def index
    @users = @account.users
    @invitations = @account.invitations
  end

  def show
    @projects = @account.projects.active
  end

  def destroy
    flash = @account.remove_user(@user) ? { :notice => t('users.flash.removed') } : { :alert => t('users.flash.remove_admin')}
    redirect_to [@account, :users], flash
  end

  def set_admin
    unless @user == current_user
      @account.set_admin_status(@user, params[:admin])
    end

    redirect_to [@account, @user]
  end

  def set_projects
    @account.set_user_projects(@user, params[:user][:project_ids])

    redirect_to [@account, @user]
  end

  private

  def get_user
    @user = @account.users.find(params[:id])
  end
end
