# Relative path to remote PBCore file
# NOTE: WE pass a lambda here to lazy eval, so we only check for env var when
#   trying to access :ov_pbcore_file. The `set' method does not take a block
#   hence the stabby lambda.
set :ov_pbcore_file, -> do
  raise ArgumentError, 'Missing required environment variable OV_PBCORE' unless ENV['OV_PBCORE']
  "ingest_data/#{File.basename(ENV['OV_PBCORE'])}"
end

namespace :ingest do
  task :upload do
    on roles(:web) do
      with rails_env: :production do
        execute :mkdir, '-p', "#{release_path}/#{File.dirname(fetch(:ov_pbcore_file))}"
        upload! ENV['OV_PBCORE'], "#{release_path}/#{fetch(:ov_pbcore_file)}"
      end
    end
  end

  task :run do
    on roles(:web) do
      with rails_env: :production do
        within release_path do
          unless test("[ -f #{release_path}/#{fetch(:ov_pbcore_file)} ]")
            raise "PBCore file not found. Upload pbcore with:\n\n\tOV_PBCORE=path/to/pbcore_file cap #{fetch(:stage)} ingest:upload\n\n"
          end
          execute :bundle, 'exec', 'ruby', "#{release_path}/scripts/ingest.rb", "--same-mount", '--files', "#{release_path}/#{fetch(:ov_pbcore_file)}"
          invoke 'deploy:restart'
        end
      end
    end
  end

  task :upload_and_run => [:upload, :run]
end