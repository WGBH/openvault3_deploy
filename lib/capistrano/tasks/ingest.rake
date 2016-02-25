task :ingest do
  on roles(:web) do
    within release_path do
      with rails_env: :production do
        execute :bundle, 'exec', 'ruby', "#{release_path}/scripts/ingest.rb", "--same-mount", '--files', '~/ov.zip'
      end
    end
  end
end