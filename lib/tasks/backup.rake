require 'active_record/fixtures'

namespace :db do
  BACKUPS_PATH = File.join(Rails.root, "db", "backups")

  desc "backup database content to yaml files"
  task :backup => :environment do
    path = "#{BACKUPS_PATH}/#{Time.now.to_i}"
    (ActiveRecord::Base.connection.tables - ["schema_migrations"]).each do |table|
      FileUtils.mkdir_p path
      File.open("#{path}/#{table}.yml", "w+") do |file|
        class_name = table.classify
        YAML.dump(class_name.constantize.all.inject({}) do |hash, record|
          hash["#{table}_#{record.id}"] = record.attributes
          hash
        end, file);

        puts "backuped: #{class_name}"
      end
    end
  end

  namespace :backup do
    desc "restore tables content from yaml files"
    task :install => :environment do
      path = ENV['version'] ? "#{BACKUPS_PATH}/#{ENV['version']}" : Dir.glob("#{BACKUPS_PATH}/*").max

      class_names = Dir.glob("#{path}/*.yml").map { |file_name| File.basename(file_name, ".yml") }

      Fixtures.create_fixtures(path, class_names)

      puts "version: #{File.basename(path)}"
      class_names.each do |class_name|
        puts "restored: #{class_name.classify}"
      end
    end
  end
end