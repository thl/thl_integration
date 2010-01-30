namespace :thl_integration do
  desc "Syncronize extra files for thdl_integration."
  task :sync do
    system "rsync -ruv --exclude '.*' vendor/plugins/thl_integration/public ."
  end
end