set :application,             "[application]"
set :application_server,      "[server]"
set :repository,              "[git repo]"
set :user,                    "[user]"

role :app, application_server
role :web, application_server
role :db,  application_server, :primary => true

set :deploy_to, "[path to deploy]"
set :use_sudo, false

set :touch_assets, %w(stylesheets images)

load "config/deploy/rollback"
load "config/deploy/revisions"
load "config/deploy/git"
load "config/deploy/default"
load "config/deploy/bundle"
load "config/deploy/db"

namespace :deploy do
  task :clear_sprockets, :except => { :no_release => true } do
    run "cd #{release_path} && RAILS_ENV=#{rails_env} bundle exec rake sprockets:clear"
  end
  task :compile_sprockets do
    run "cd #{release_path} && RAILS_ENV=#{rails_env} bundle exec rake sprockets:compile"
  end

  task :sass_update do
    run "cd #{release_path} && bundle exec compass compile -e production --force"
  end
end

after 'deploy:setup', 'deploy:setup_shared'
after 'deploy:update_code', 'deploy:clear_sprockets'
after 'deploy:update_code', 'deploy:compile_sprockets'
after 'deploy:update_code', 'deploy:sass_update'

require 'config/boot'
require 'hoptoad_notifier/capistrano'
