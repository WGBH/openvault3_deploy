namespace :api do
  desc "Sets Transcript API credentials"
  task :add_credentials_to_env_variables do
    on roles(:app) do
      execute :sudo, "printf", "'export API_USER=api-user\nexport API_PASSWORD=L08UA637dyd' >> ~/.bashrc && source ~/.bashrc"
    end
  end
end
