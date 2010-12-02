namespace :thl_integration do
  desc "Syncronize extra files for thdl_integration."
  task :sync do
    system "rsync -ruv --exclude '.*' vendor/plugins/thl_integration/public ."
  end
  
  desc "Installs dependent plugins for basic engine."
  task :install_dependencies do
    if File.exists?(File.join(RAILS_ROOT, '.svn'))
      svn_option = '-x' # for external use '-e'
      ['http://repo.pragprog.com/svn/Public/plugins/annotate_models',
       'https://ndlb.svn.sourceforge.net/svnroot/ndlb/portal/ror/plugins/authenticated_system/trunk',
       'http://ndlb.svn.sourceforge.net/svnroot/ndlb/portal/ror/plugins/complex_scripts/trunk',
       'http://dev.rubyonrails.org/svn/rails/plugins/in_place_editing'].each{ |plugin| system "script/plugin install #{svn_option} #{plugin}"}
      # git
      ['git://github.com/joshmh/globalize2.git',
       'git://github.com/rails/open_id_authentication.git',
       'git://github.com/technoweenie/restful-authentication.git'].each{ |plugin| system "script/plugin install #{plugin}"}
    else
      git_installers = { 'annotate_models' => 'git://github.com/amontano/annotate_models.git', 'authenticated_system' => 'git://github.com/thl/authenticated_system.git', 'complex_scripts' => 'git://github.com/thl/complex_scripts.git', 'globalize2' => 'git://github.com/joshmh/globalize2.git', 'jrails' => 'git://github.com/aaronchi/jrails.git', 'open_id_authentication' => 'git://github.com/rails/open_id_authentication.git', 'restful-authentication'  => 'git://github.com/technoweenie/restful-authentication.git', 'universal_navigation' => 'git://github.com/thl/universal_navigation.git' }
      if File.exists?(File.join(RAILS_ROOT, '.git'))
        git_installers.each do |plugin, url| 
          path = "vendor/plugins/#{plugin}"
          system "git submodule add #{url} #{path}" if !File.exists?(File.join(RAILS_ROOT, path))
        end
      else
        git_installers.each { |plugin, url| system "script/plugin install #{url}" if !File.exists?(File.join(RAILS_ROOT, "vendor/plugins/#{plugin}")) }
      end
    end
  end

  desc "Copies necessary migrations and public files of dependencies."   
  task :deploy_dependencies do
    ['authenticated_system', 'thl_integration', 'complex_scripts'].each{|plugin|  system "rake #{plugin}:sync" }
  end
end