Taskar::Application.routes.draw do
  resources :projects, :only => [] do
    resources :statuses, :only => [:create, :index, :destroy] do
      collection do
        delete :clear
      end
    end

    resources :aside, :only => :index

    resources :tasks, :only => :index do
      collection do
        put :reorder
        get :search
      end
    end

    resources :sections, :shallow => true do
      member do
        put :archive
      end

      collection do
        put :reorder
        get :tasks
        get :archived
      end

      resources :tasks, :shallow => true, :except => [:new, :index] do
        member do
          put :state
          put :archive
          put :section
        end

        collection do
          get :archived
        end

        resources :comments, :shallow => true, :except => [:index, :new]
      end
    end
  end

  resources :accounts, :controller => "accounts/accounts", :only => [:show, :edit, :update] do
    resources :invitations, :controller => "accounts/invitations", :only => [:new, :create, :update, :destroy]

    resources :users, :controller => "accounts/users", :except => [:new, :create, :edit, :update] do
      member do
        put :set_admin
        put :set_projects
      end
    end

    resources :projects, :controller => "accounts/projects" do
      member do
        put :complete
      end
    end
  end

  devise_for :users, :controllers => { :registrations => "sign/registrations" }, :path => "sign", :path_names => {:sign_in => "in", :sign_out => "out", :sign_up => "up"}

  namespace :sign do
    resources :invitations, :only => [:show, :update]
  end

  match 'changes' => 'changelog#index', :via => :get

  match 'issues' => 'issues#create', :via => :post

  match '/backdoor-login', :to => 'backdoor_login#login', :via => :get if Rails.env.test?

  root :to => "dashboard#index"
end
