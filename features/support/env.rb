require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= "test"
  require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')

  require 'cucumber/rails'
  require 'cucumber/rspec/doubles'

  require 'capybara/rails'
  require 'capybara/cucumber'
  require 'capybara/session'

  require 'email_spec'
  require 'email_spec/cucumber'

  ActionController::Base.allow_rescue = false

  Capybara.default_selector = :css
  Cucumber::Rails::World.use_transactional_fixtures = true

  ActionController::Base.allow_rescue = false

  DatabaseCleaner.strategy = :deletion

  ActiveSupport::Dependencies.clear if Spork.using_spork?
end

Spork.each_run do
  I18n.reload!

  World(Factory::Syntax::Methods)

  Taskar::Application.reload_routes!
end