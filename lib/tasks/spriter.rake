require "yaml"
require "spriter"

desc "Generate sprite form config/spriter.yml options"
task :spriter do
  options = YAML::load( open("#{Rails.root}/config/spriter.yml") )

  Spriter.generate options["sprite"], options["images"]

  puts "#{options["sprite"]} generated succesfully"
end