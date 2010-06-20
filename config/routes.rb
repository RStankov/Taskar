ActionController::Routing::Routes.draw do |map|
  map.resources :projects do |projects|
    projects.resources :sections, :shallow => true do |sections|
      sections.resources :tasks, :shallow => true, :except => [:new, :index], :member => {:state => :put}, :collection => {:reorder => :put} do |tasks|
        tasks.resources :comments, :shallow => true, :except => [:index, :new]
      end
    end
  end

  map.devise_for :users, :as => 'sign', :path_names => {:sign_in => 'in', :sign_out => 'out', :sign_up => 'up'}

  SprocketsApplication.routes(map)
  
  map.root :controller => 'projects', :action => 'index'
end
