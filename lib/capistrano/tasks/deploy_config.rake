namespace :deploy do

  task :ensure_shared_config_dir do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
    end
  end

  namespace :config do
    task :all do
      # only necessary for AAPB, openvault equivalent is in OV repo
      if ENV['APP_NAME'] == 'AAPB'
        invoke "deploy:config:ci"
        invoke "deploy:config:database"
        invoke "deploy:config:secrets"
      end
    end

    task :ci => [:ensure_shared_config_dir] do
      on roles(:app) do
        upload! './config/ci.yml', "#{shared_path}/config/ci.yml"
      end
    end

    task :database => [:ensure_shared_config_dir] do
      on roles(:app) do
        upload! './config/database.yml', "#{shared_path}/config/database.yml"
      end
    end

    task :secrets => [:ensure_shared_config_dir] do
      on roles(:app) do
        upload! './config/secrets.yml', "#{shared_path}/config/secrets.yml"
      end
    end

    task :remove_duplicate_passenger do
      on roles(:web) do
        execute 'sudo rm -rf /usr/local/bin/passenger'
      end
    end

  end
end