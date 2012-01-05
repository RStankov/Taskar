class BackdoorLoginController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :set_locale

  def login
    raise "Use only on testing env" unless Rails.env.test?
    sign_in User.find_by_email! params[:email]
    head :ok
  end
end