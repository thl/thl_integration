namespace :thdl_integration do
  desc "Syncronize extra files for thdl_integration."
  task :sync do
    system "rsync -ruv --exclude '.*' vendor/plugins/thdl_integration/public ."
  end
end