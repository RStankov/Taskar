class Accounts::UsersController < Accounts::BaseController
  layout 'users'

  def index
  end

  def show
    @member = find_member
  end

  def destroy
    member = find_member

    if member.removable?
      member.remove

      redirect_to account_users_path(member.account), :notice => 'User deleted succesfully.'
    else
      redirect_to account_user_path(member.account, member), :alert => 'Administrators could not be deleted.'
    end
  end

  def set_admin
    member = find_member

    unless member == current_user
      member.set_admin_status_to params[:admin]
    end

    redirect_to account_user_path(member.account, member)
  end

  def set_projects
    member = find_member
    member.set_projects params[:user][:project_ids] || []

    redirect_to account_user_path(member.account, member)
  end

  private

  def find_member
    AccountMember.find @account, params[:id]
  end
end
