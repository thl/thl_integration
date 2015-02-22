module ThlIntegration
  class Engine < ::Rails::Engine
    initializer :assets do |config|
      Rails.application.config.assets.precompile.concat(['thl_integration/service_plug.js', 'thl_integration/thl_iframe_adjustment.css'])
    end
  end
end
