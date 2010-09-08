set(:scm)                   { "git" }
set(:scm_passphrase)        { "" }
set(:branch)                {"master" }
set(:git_enable_submodules) { 1 }

default_run_options[:pty] = true  # Must be set for the password prompt from git to work

namespace :deploy do
  desc "Setup a GitHub-style deployment."
  task :setup, :except => { :no_release => true } do
    dirs = [deploy_to, shared_path] + shared_children.map { |d| File.join(shared_path, d) }
    dirs = dirs.join(' ')
    run "#{try_sudo} mkdir -p #{dirs} && #{try_sudo} chmod g+w #{dirs}"
  
    run [
      "git clone #{repository} #{current_path}",
      "cd #{current_path}",
      "git submodule init",
      "git submodule update"
    ].join(" && ")
  end

  desc "Update the deployed code."
  task :update_code, :except => { :no_release => true } do    
    run [
      "cd #{current_path}",
      "git fetch",
      "git submodule update",
      "git reset --hard origin/#{branch}"
    ].join(" && ")

    finalize_update
  end
end