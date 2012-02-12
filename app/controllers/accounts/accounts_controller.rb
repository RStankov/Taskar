class Accounts::AccountsController < Accounts::BaseController
  before_filter :allow_only_account_owner, :only => [:edit, :update]

  def show
  end

  def edit
  end

  def update
    if @account.update_attributes(params[:account])
      redirect_to @account, :notice => 'Account information updated successfully'
    else
      render 'edit'
    end
  end

  private

  def account_id
    params[:id]
  end

  def allow_only_account_owner
    deny_access unless @account.owner? current_user
  end
end
