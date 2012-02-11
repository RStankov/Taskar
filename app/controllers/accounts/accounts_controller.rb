class Accounts::AccountsController < Accounts::BaseController
  before_filter :allow_only_account_owner, :only => [:edit, :update]

  def show
    @projects = @account.projects.active
  end

  def edit
  end

  def update
    @account.instance_variable_set('@readonly', false)
    if @account.update_attributes(params[:account])
      redirect_to @account, :notice => t('accounts.updated')
    else
      render 'edit'
    end
  end

  private

  def account_id
    params[:id]
  end

  def allow_only_account_owner
    if @account.owner_id != current_user.id
      deny_access
    end
  end
end
