# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_Taskar_session',
  :secret      => '513dfdd0bedcea050f98df362e2c97226f7b73827ea9813fa97cebf584d6ca48d5fb1324ea00c820722fc8306955b7bb47b8a8c65972cfdd7a9c2edb1c04a6b4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
