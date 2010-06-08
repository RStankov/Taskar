module Taskar
  module Auth
    module SpecHelper
      # Quick access to Devise::TestHelpers::TestWarden.
      def warden #:nodoc:
        unless @warden
          # We need to setup the environment variables and the response in the controller.
          @request.env['action_controller.rescue.request']  = @request
          @request.env['action_controller.rescue.response'] = @response
          @request.env['rack.session'] = session
          @controller.response = @response
          @warden = (@request.env['warden'] = Devise::TestHelpers::TestWarden.new(@controller))
        end
        @warden
      end

      # sign_in a given resource by storing its keys in the session.
      #
      # Examples:
      #
      #   sign_in :user, @user   # sign_in(scope, resource)
      #   sign_in @user          # sign_in(resource)
      #
      def sign_in(resource_or_scope, resource=nil)
       scope    ||= Devise::Mapping.find_scope!(resource_or_scope)
       resource ||= resource_or_scope

       warden.session_serializer.store(resource, scope)
      end

      # Sign out a given resource or scope by calling logout on Warden.
      #
      # Examples:
      #
      #   sign_out :user     # sign_out(scope)
      #   sign_out @user     # sign_out(resource)
      #
      def sign_out(resource_or_scope)
       scope = Devise::Mapping.find_scope!(resource_or_scope)
       @controller.instance_variable_set(:"@current_#{scope}", nil)
       warden.logout(scope)
      end
    end
  end
end