require 'spork'

Spork.prefork do
  ENV['RAILS_ENV'] ||= 'test'

  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'
  require 'paperclip/matchers'

  if Spork.using_spork?
    ActiveSupport::Dependencies.clear
    ActiveRecord::Base.instantiate_observers
  end
end

Spork.each_run do
  Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

  Taskar::Application.reload_routes!

  # match ActiveRecord collections with =~
  RSpec::Matchers::OperatorMatcher.register(ActiveRecord::Relation, '=~', RSpec::Matchers::MatchArray)

  RSpec.configure do |config|
    config.mock_with :rspec
    config.use_transactional_fixtures = true

    config.include Factory::Syntax::Methods
    config.include Paperclip::Shoulda::Matchers, :type => :model
    config.include EmailSpec::Helpers
    config.include EmailSpec::Matchers
    config.include Devise::TestHelpers, :type => :controller

    config.include SpecSupport::Mocks
    config.include SpecSupport::Controller, :type => :controller

    config.extend SpecSupport::Controller::Autentication, :type => :controller
    config.extend SpecSupport::Model::Validation, :type => :model
  end
end