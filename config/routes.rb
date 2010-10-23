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
    resources :invitations, :only => [:show, :update, :destroy] do
      member_scope do
        post :create_user
      end
    end
  end

  match "issues" => "issues#create", :via => :post
  match "sprockets.js" => "sprockets#show"

  root :to => "dashboard#index"
end
