ActionController::Routing::Routes.draw do |map|

  map.namespace(:thl) do |thl|
    thl.connect 'utils/proxy/*proxy_url', :controller => 'utils', :action => 'proxy'
  end

end