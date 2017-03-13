desc 'Print the current Git revision'
task :revision do
  on roles(:web) do
    within current_path do
      puts "\nCurrent Git revision: #{capture(:cat, "REVISION")}\n\n"
    end
  end
end
