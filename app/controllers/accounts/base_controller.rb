class Accounts::BaseController < ApplicationController
  layout 'accounts'

  before_filter :get_account_and_check_permissions

  prepend_view_path Rails.root.join('app', 'views', 'accounts')

  private

  def account_id
    params[:account_id]
  end

  def get_account_and_check_permissions
    @account = current_user.find_account(account_id)
    @current_member = AccountMember.new(current_user, @account)

    deny_access unless @current_member.admin?
  end

  def current_member
    @current_member
  end
end