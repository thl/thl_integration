$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "thl_integration/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "thl_integration"
  s.version     = ThlIntegration::VERSION
  s.authors     = ["Andres Montano"]
  s.email       = ["amontano@virginia.edu"]
  s.homepage    = "http://subjects.kmaps.virginia.edu"
  s.summary     = "Engine to facilitate connecting to the THL"
  s.description = "Engine to facilitate connecting to the THL"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0"
  # s.add_dependency "jquery-rails"
  s.add_dependency 'hpricot' #, '>= 0.8.6'

  s.add_development_dependency "sqlite3"
end
