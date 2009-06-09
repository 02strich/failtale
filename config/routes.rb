ActionController::Routing::Routes.draw do |map|
  
  map.namespace :admin do |admin|
    map.resources :users
    map.resources :invitation_requests
  end
  
  map.resource :user_session, :only => [:new, :show, :create, :destroy]
  map.resource :account, :only => [:new, :edit, :create, :update], :controller => 'users'
  map.resources :invitations, :only => [:new, :create]
  map.resources :invitation_requests, :only => [:new, :create]
  
  map.resource :reports, :only => :create
  map.resources :errors, :only => :index
  map.resources :projects, :shallow => true,
    :member => { :close_all_errors => :put, :closed => :get } do |projects|
    projects.resources :memberships, :only => [:new, :create, :edit, :update, :destroy]
    projects.resources :errors, :shallow => true, :only => [:show, :update] do |errors|
      errors.resources :occurences, :only => [:show],
        :member => { :backtrace => :get, :environment => :get }
    end
  end
  
  map.home 'home', :controller => 'pages', :action => 'home'
  map.root :controller => 'projects', :action => 'index'
  
  map.resources :service_settings
  
end
