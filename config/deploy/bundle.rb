set(:bundle_cmd)      { "bundle" }
set(:bundle_flags)    { "--deployment --quiet" }
set(:bundle_dir)      { File.join(shared_path, 'bundle') }
set(:bundle_gemfile)  { "Gemfile" }
set(:bundle_without)  { [:development, :test] }

namespace :bundle do
  desc <<-DESC
    Install the current Bundler environment. By default, gems will be \
    installed to the shared/bundle path. Gems in the development and \
    test group will not be installed. The install command is executed \
    with the --deployment and --quiet flags. You can override any of \
    these defaults by setting the variables shown below. If the bundle \
    cmd cannot be found then you can override the bundle_cmd variable \
    to specifiy which one it should use.

      set :bundle_gemfile,      "Gemfile"
      set :bundle_dir,          File.join(fetch(:shared_path), 'bundle')
      set :bundle_flags,        "--deployment --quiet"
      set :bundle_without,      [:development, :test]
      set :bundle_cmd,          "bundle" # e.g. change to "/opt/ruby/bin/bundle"
  DESC

  task :install, :except => { :no_release => true } do
      bundle_without_array = [*bundle_without].compact

      args = ["--gemfile #{File.join(current_path, bundle_gemfile)}"]
      args << "--path #{bundle_dir}" unless bundle_dir.to_s.empty?
      args << bundle_flags.to_s
      args << "--without #{bundle_without_array.join(" ")}" unless bundle_without_array.empty?

      run "#{bundle_cmd} install #{args.join(' ')}"
  end
end


after "deploy:update_code", "bundle:install"