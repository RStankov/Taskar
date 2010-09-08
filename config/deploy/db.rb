namespace :db do
  task :seed do
    preform_rake_task "db:seed"
  end
  
  namespace :backup do
    task :default do
      preform_rake_task "db:backup"
    end
    
    task :restore do
      preform_rake_task "db:backup:install"
    end
  end
end