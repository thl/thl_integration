module ThlIntegration
  class Engine < ::Rails::Engine
    initializer :assets do |config|
      Rails.application.config.assets.precompile.concat(['thl_integration/service_plug.js'])
    end
  end
end
