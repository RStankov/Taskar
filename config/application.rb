require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Taskar
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    config.autoload_paths     += %w[#{config.root}/lib]
    config.time_zone           = "UTC"
    config.i18n.default_locale = :en
    config.encoding            = "utf-8"
    config.filter_parameters  += [:password, :password_confirmation]
    config.assets.enabled      = true
    config.assets.version      = '1.0'
    config.action_mailer.default_url_options = ApplicationConfig.action_mailer

    ### Part of a Spork hack. See http://bit.ly/arY19y
    if Rails.env.test? && defined?(Spork) && Spork.using_spork?
      initializer :after => :initialize_dependency_mechanism do
        # Work around initializer in railties/lib/rails/application/bootstrap.rb
        ActiveSupport::Dependencies.mechanism = :load
      end
    end
  end
end
