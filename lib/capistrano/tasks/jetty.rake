namespace :jetty do
  # Open Vault has a `jetty:restart` task, but it doesn't work in the context
  # of capistrano. Here we have to explicitly stop, then start. Also, we add a
  # friendlier error message if jetty is not currently present.
  desc 'Restarts jetty'
  task :restart do
    on roles(:web) do
      within release_path do
        with rails_env: :production do
          if test "[ ! -L #{release_path}/jetty ]"
            raise 'No jetty detected. Install jetty with: bundle exec cap [stage] jetty:install'
          end

          # This is a little hairy, but it gets the PIDs of all running jetty
          # processes. There shouldn't be more than 1, but we want to kill
          # them all.
          jetty_pids = capture("ps ax | grep 'jetty/solr -jar start.jar' | grep -v 'grep' | awk '{print $1}'").split(/\s/)
          jetty_pids.each do |jetty_pid|
            execute :kill, jetty_pid
          end
          execute :rake, 'jetty:start'
        end
      end
    end
  end

  desc 'Installs a new jetty instance if one does not exist'
  task :install do
    on roles(:web) do
      within release_path do
        with rails_env: :production do
          # Download a clean copy of jetty if one doesn't already exist
          if test "[ ! -d #{shared_path}/jetty ]"
            execute :rake, 'jetty:clean'
            execute :mv, 'jetty', shared_path
          end

          # Create link to shared jetty if it doesn't already exists
          execute :ln, '-s', "#{shared_path}/jetty"  if test("[ ! -L #{release_path}/jetty ]")

          # Configure and restart jetty instance
          execute :rake, 'jetty:config'

          # Use our own jetty:restart instead of `rake jetty:restart`, which
          # does not work when invoked from Capistrano.
          invoke 'jetty:restart'
        end
      end
    end
  end

  desc 'WARNING!!! Uninstalls jetty and all the data with it!'
  task :uninstall do
    on roles(:web) do
      within release_path do
        with rails_env: :production do
          # Remove the shared jetty instance
          execute :rm, '-rf', "#{shared_path}/jetty"

          # Remove symlink to shared jetty instance if it exists
          if test("[ -L #{release_path}/jetty ]")
            execute :rm, "#{release_path}/jetty"  
          end
        end
      end
    end
  end
end
