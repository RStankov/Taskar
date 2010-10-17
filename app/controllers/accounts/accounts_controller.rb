class Accounts::AccountsController < Accounts::BaseController
  def show
  end

  def edit
  end

  def update
    if @account.update_attributes(params[:account])
      redirect_to @account, :notice => "Account info updated succesfully"
    else
      render "edit"
    end
  end

  protected
    def account_id
      params[:id]
    end
end
