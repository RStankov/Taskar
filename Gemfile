source "http://rubygems.org"

gem 'rake', '0.8.7'
gem 'rails', '3.1.3'

group :assets do
  gem 'sass-rails',   '~> 3.1.4'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier',     '>= 1.0.3'
  gem 'compass',      '~> 0.12.alpha'
end

gem "paperclip", "2.3.3"
gem 'will_paginate', '3.0.2'
gem 'devise', '1.3.4'

gem "acts_as_list", "~>0.1.2"

gem "hoptoad_notifier"
gem "newrelic_rpm"

gem 'confu', :git => 'git@github.com:garmz/confu.git'

gem 'spork', '~> 0.9.0.rc9'

group :development do
  gem 'sqlite3-ruby', :require => 'sqlite3'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'cucumber-rails'
  gem 'pry'
end

group :test do
  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'factory_girl_rails'
  gem 'selenium-webdriver', '= 2.14.0'
end
