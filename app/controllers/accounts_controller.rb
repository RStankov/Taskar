class AccountsController < ApplicationController
  layout "admin"

  before_filter :get_account

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

  private
    def get_account
      @account = current_user.owned_accounts.find(params[:id])
    end
end
