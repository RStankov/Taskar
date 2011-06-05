require File.expand_path("../boot", __FILE__)

require "rails/all"

# If you have a Gemfile, require the gems listed there, including any gems
# you"ve limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Taskar
  class Application < Rails::Application
    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    config.autoload_paths += %W(#{config.root}/lib)
    config.time_zone = "UTC"
    config.i18n.default_locale = :en
    config.encoding = "utf-8"
    config.filter_parameters += [:password, :password_confirmation]
    config.action_mailer.default_url_options = ApplicationConfig.action_mailer
  end
end
