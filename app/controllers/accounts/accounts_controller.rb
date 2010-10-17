class Accounts::AccountsController < Accounts::BaseController
  def show
  end

  def edit
  end

  def update
    @account.instance_variable_set("@readonly", false)
    if @account.update_attributes(params[:account])
      redirect_to @account, :notice => t("accounts.updated")
    else
      render "edit"
    end
  end

  protected
    def account_id
      params[:id]
    end
end
