class AccountsController < ApplicationController
  before_filter :get_account

  def show
  end

  def edit
  end

  def update
    if @account.update_attributes(params[:account])
      redirect_to root_path, :notice => "Account info updated succesfully"
    else
      render "edit"
    end
  end

  private
    def get_account
      @account = Account.find(params[:id])
    end
end
