Taskar::Application.routes.draw do |map|
  map.resources :users, :member => {:set_admin => :put}
  map.resources :projects, :member => {:complete => :put} do |projects|
    projects.resources :statuses, :only => [:create, :index, :destroy], :collection => {:clear => :delete}
    projects.resources :aside, :only => :index
    projects.resources :tasks, :collection => {:reorder => :put, :search => :get}, :only => [:index]
    projects.resources :sections, :shallow => true, :collection => {:reorder => :put, :tasks => :get, :archived => :get}, :member => {:archive => :put} do |sections|
      sections.resources :tasks, :shallow => true, :except => [:new, :index], :member => {:state => :put, :archive => :put, :section => :put}, :collection => {:archived => :get} do |tasks|
        tasks.resources :comments, :shallow => true, :except => [:index, :new]
      end
    end
  end

  #map.devise_for :users, :as => "sign", :path_names => {:sign_in => "in", :sign_out => "out", :sign_up => "up"}

  SprocketsApplication.routes(map)

  map.root :controller => "dashboard", :action => "index"
end
