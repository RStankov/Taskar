namespace :deploy do
  desc "Deploy the MFer"
  task :default do
    update
    restart
  end

  desc <<-DESC
    Deploy and run pending migrations. This will work similarly to the
    `deploy' task, but will also run any pending migrations (via the
    `deploy:migrate' task) prior to updating the symlink. Note that the
    update in this case it is not atomic, and transactions are not used,
    because migrations are not guaranteed to be reversible.
  DESC
  task :migrations do
    set :migrate_target, :current
    update_code
    symlink
    migrate
    restart
  end

  desc <<-DESC
    [internal] Touches up the released code. This is called by update_code
    after the basic deploy finishes. It assumes a Rails project was deployed,
    so if you are deploying something else, you may want to override this
    task with your own environment's requirements.

    This will touch all assets in :assets_folders so that the times are
    consistent (so that asset timestamping works).  This touch process
    is only carried out if the :normalize_asset_timestamps variable is
    set to true, which is the default.
  DESC
  task :finalize_update, :except => { :no_release => true } do
    if fetch(:normalize_asset_timestamps, true)
      stamp = Time.now.utc.strftime("%Y%m%d%H%M.%S")
      asset_paths = fetch(:touch_assets) { %w(images css javascripts) }.map { |p| "#{current_path}/public/#{p}" }.join(" ")
      run "find #{asset_paths} -exec touch -t #{stamp} {} ';'; true", :env => { "TZ" => "UTC" }
    end
  end

  desc "Symlink system files & set revision info"
  task :symlink, :except => { :no_release => true } do
    run [
      "rm -rf #{current_path}/log #{current_path}/public/system #{current_path}/tmp/pids #{current_path}/.htaccess",
      "mkdir -p #{current_path}/public",
      "mkdir -p #{current_path}/tmp",
      "ln -s #{shared_path}/log       #{current_path}/log",
      "ln -s #{shared_path}/system    #{current_path}/public/system",
      "ln -s #{shared_path}/pids      #{current_path}/tmp/pids",
      "ln -s #{shared_path}/htaccess  #{current_path}/.htaccess"
    ].join(" && ")
  end

  desc "Do nothing (since we have no releases directory)"
  task :cleanup do
  end

  desc "Setup shared files (htaccess)"
  task :setup_shared do
    run 'echo "PassengerMinInstances 3" > #{shared_path}/htaccess'
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end