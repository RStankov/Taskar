# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  before_filter :authenticate_user!
  
  protected 
    def deny_access
      if request.xhr?
        head :forbidden
      else
        redirect_to root_path
      end
    end
end
