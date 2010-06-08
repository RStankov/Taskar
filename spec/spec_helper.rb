# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'

require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'spec/autorun'
require 'spec/rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

# add thoughtbot's shoulda / factory girl / paperclip matchers
require 'shoulda'
require 'factory_girl'
require 'paperclip/matchers'

Spec::Runner.configure do |config|
  config.include Paperclip::Shoulda::Matchers
  config.include Taskar::Auth::SpecHelper
end
