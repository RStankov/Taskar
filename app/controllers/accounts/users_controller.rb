class Accounts::UsersController < Accounts::BaseController
  layout 'users'

  def index
  end

  def show
    @member = find_member
  end

  def destroy
    user = find_user
    flash = @account.remove_user(user) ? { :notice => 'User deleted succesfully.' } : { :alert => 'Administrators could not be deleted.'}
    redirect_to account_users_path(@account), flash
  end

  def set_admin
    user = find_user

    unless user == current_user
      @account.set_admin_status(user, params[:admin])
    end

    redirect_to account_user_path(@account, user)
  end

  def set_projects
    user = find_user

    @account.set_user_projects(user, params[:user][:project_ids])

    redirect_to account_user_path(@account, user)
  end

  private

  def find_member
    AccountMember.find @account, params[:id]
  end

  def find_user
    @account.users.find(params[:id])
  end
end
