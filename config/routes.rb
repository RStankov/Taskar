ActionController::Routing::Routes.draw do |map|
  map.resources :projects

  map.devise_for :users, :as => 'sign', :path_names => {:sign_in => 'in', :sign_out => 'out', :sign_up => 'up'}

  SprocketsApplication.routes(map)
  
  map.root :controller => 'sessions', :action => 'new'
end
