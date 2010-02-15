ActionController::Routing::Routes.draw do |map|

  map.namespace(:thl) do |thl|
    thl.connect 'utils/proxy/', :controller => 'utils', :action => 'proxy'
  end

end
