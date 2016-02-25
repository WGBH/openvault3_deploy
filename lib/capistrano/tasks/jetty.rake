namespace :jetty do

  task :config do
    on roles(:web) do
      within release_path do
        with rails_env: :production do
          execute :rake, 'jetty:config'
        end
      end
    end
  end

  task :start do
    on roles(:web) do
      within release_path do
        with rails_env: :production do
          execute :rake, 'jetty:start'
        end
      end
    end
  end

  task :clean do
    on roles(:web) do
      within release_path do
        with rails_env: :production do
          execute :rm, '-rf', "#{shared_path}/jetty"
          execute :rake, 'jetty:clean'
          execute :mv, 'jetty', shared_path
          execute :ln, '-s', "#{shared_path}/jetty"
        end
      end
    end
  end

  task :prepare => [:clean, :config, :start]
end