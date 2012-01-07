# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery

  before_filter :authenticate_user!
  # before_filter :set_locale

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  protected
    def deny_access
      if request.xhr?
        head :forbidden
      else
        redirect_to root_path, :alert => I18n.t(:deny_access)
      end
    end

    def check_project_permissions
      unless @project && @project.involves?(current_user)
        deny_access
      end
    end

    def activity(subject)
      Event.activity(current_user, subject)
    end

    def record_not_found
      render :action => "shared/not_found", :layout => "application", :status => 404
    end

    def get_project
      @project = Project.find(params[:project_id])
    end

    def project_user
      @project_user ||= ProjectUser.find_by_user_id_and_project_id(current_user.id, @project.id)
    end

    def set_locale
      set_locale_from current_user.locale if user_signed_in? && current_user.locale
    end

    def set_locale_from_param
      set_locale_from params[:locale] if params[:locale]
    end

  private
    def set_locale_from(locale)
      locale = locale.to_sym
      if locale && I18n.available_locales.include?(locale)
         I18n.locale = locale
      end
    end
end
