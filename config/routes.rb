Rails.application.routes.draw do
  namespace :thl do
    match 'utils/proxy/' => 'utils#proxy'
  end
end