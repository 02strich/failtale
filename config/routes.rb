ActionController::Routing::Routes.draw do |map|
  
  map.resource :user_session
  map.resource :account, :controller => "users"
  map.resources :users
  map.resources :invitations
  
  map.resource :reports, :only => :create 
  map.resources :projects do |projects|
    projects.resources :memberships
    projects.resources :errors
  end
  
  map.home 'home', :controller => 'pages', :action => 'home'
  map.root :controller => 'projects', :action => 'index'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
