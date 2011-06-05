# Be sure to restart your server when you modify this file.

Taskar::Application.config.session_store :cookie_store, :key => ApplicationConfig.app_cookie_key

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# Foo::Application.config.session_store :active_record_store
