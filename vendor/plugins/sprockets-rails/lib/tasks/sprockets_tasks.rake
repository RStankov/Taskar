namespace :sprockets do
  desc "Clear sprockets cache"
  task :clear do
    require 'fileutils'

    path = File.join(Rails.public_path, "sprockets.js")
    if File.directory? path
      FileUtils.rm_r path
    end
  end

end