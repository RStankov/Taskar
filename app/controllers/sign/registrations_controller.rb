class Sign::RegistrationsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [ :new, :create ]
  skip_before_filter :set_locale, :only => [ :new, :create ]

  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to :root, :notice => t("devise.registrations.signed_up")
    else
      @user.clean_up_passwords
      render "new"
    end
  end

  def edit
  end

  def update
    if is_password_required ? current_user.update_with_password(params[:user]) : current_user.update_attributes(params[:user])
      redirect_to edit_user_registration_path, :notice => t("devise.registrations.updated")
    else
      current_user.clean_up_passwords
      render "edit"
    end
  end

  def destroy
    redirect_to :root
  end

  protected
    def require_no_authentication
      if user_signed_in?
        redirect_to :root
      end
    end

    def controller_path
      "devise/registrations"
    end

    def is_password_required
      unless data = params[:user]
        return false
      end

      if data[:password].present? || data[:password_confirmation].present?
        return true
      end

      data[:email] && data[:email] != current_user.email
    end
end