task :ingest do
  on roles(:web) do
    local_path = ENV['OV_PBCORE'].to_s.strip
    raise ArgumentError, 'Missing required environment variable OV_PBCORE' if local_path == ''

    # Create the dir that stores the ingest source files or directories, if it doesn't already exist.
    remote_ingest_data_dir = "#{shared_path}/tmp/ingest_data"
    execute :mkdir, '-p', remote_ingest_data_dir

    if File.directory? local_path
      ingest_source_type = '--dirs'
    elsif File.file? local_path
      ingest_source_type = '--files'
    else
      raise ArgumentError, "OV_PBCORE must be a file or directory path, but '#{ENV['OV_PBCORE']}' was given"
    end

    # TODO: clear out remote_ingest_data_dir directory before uploading?
    upload! local_path, remote_ingest_data_dir, recursive: true

    within release_path do
      with rails_env: :production do
        # Start jetty if it isn't already running.
        jetty_status = capture :bundle, 'exec', 'rake', 'jetty:status'
        if jetty_status == 'Not running'
          invoke 'jetty:restart'
        end

        remote_ingest_data_path = "#{remote_ingest_data_dir}/#{File.basename(local_path)}"
        execute :bundle, 'exec', 'ruby', "#{release_path}/scripts/ingest.rb", ingest_source_type, remote_ingest_data_path

        # Restart the rails app
        invoke 'deploy:restart'
      end
    end
  end
end
