set(:revision_log)   { "#{deploy_to}/revisions.log" }
set(:version_file)   { "#{current_path}/REVISION" }

namespace :revisions do
  desc "Set the revisions file. This allows us to go back to previous versions."
  task :set, :except => { :no_release => true } do
   set_file
   update_log
  end

  task :set_file, :except => { :no_release => true } do
   run [
     "cd #{current_path}",
     "git rev-list HEAD | head -n 1 > #{version_file}"
   ].join(" && ")
  end

  task :update_log, :except => { :no_release => true } do
   run "echo `date +\"%Y-%m-%d %H:%M:%S\"` $USER $(cat #{version_file}) >> #{revision_log}"
  end
end

after "deploy:symlink", "revisions:set"