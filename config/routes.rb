Authlogic::Application.routes.draw do

themes_for_rails

  resources :users

  resource :user_session
  resources :activations
  resources :videos
  resources :posts
  resources :blogs


  resources :password_resets

  resource :dashboard, :controller => "dashboard"
  match '/register/:activation_code', :to => 'activations#new' ,:as => "register"
  match '/activate/:id', :to => 'activations#create', :as => "activate"
  match '/signup', :to => 'users#new', :as => "signup"
  match '/login', :to => 'user_sessions#new', :as => "login"
  match '/logout', :to => 'user_sessions#destroy', :as => "logout"
  match '/myaccount/:id', :to =>'users#edit', :as => "myaccount"

  match '/profile/:login', :controller => 'profile', :action => 'show'
  match '/profile/edit/:login', :controller => 'profile', :action => 'edit'
  namespace :admin do
    match '/index', :to => 'index#index', :as => "index"
    match '/index/jobs', :to => 'index#jobs', :as => "jobs"
    resources :users, :member => { :make_admin => :put, :remove_admin => :put}
  end



  root :to => 'index#index'

  match '/:controller(/:action(/:id))'


end
