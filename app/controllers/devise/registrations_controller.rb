class Devise::RegistrationsController < ApplicationController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  include Devise::Controllers::InternalHelpers

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to :root, :notice => t("devise.registrations.signed_up")
    else
      clean_up_passwords(@user)
      render :new
    end
  end

  def edit
  end

  def update
    if is_password_required ? current_user.update_with_password(params[:user]) : current_user.update_attributes(params[:user])
      redirect_to user_registration_path, :notice => t("devise.registrations.updated")
    else
      clean_up_passwords(current_user)
      render :edit
    end
  end

  def destroy
    redirect_to :root
  end

  protected
    def is_password_required
      return false unless data = params[:user]

      data[:password].present? || data[:password_confirmation].present? || (data[:email] && data[:email] != current_user.email)
    end
end