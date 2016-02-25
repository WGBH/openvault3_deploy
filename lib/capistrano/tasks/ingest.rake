task :ingest do



  on roles(:web) do
    # TODO: remove same-mount
    # TODO background the process
    execute "cd #{release_path} && bundle exec ruby #{release_path}/scripts/ingest.rb --same-mount --files ~/ov.zip"
  end
end