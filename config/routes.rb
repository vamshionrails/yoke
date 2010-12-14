Authlogic::Application.routes.draw do

themes_for_rails

  resources :users
  resource :user_session
  resources :activations

  resources :password_resets


  #map.resource :profile
  resource :dashboard, :controller => "dashboard"
  match '/register/:activation_code', :to => 'activations#new' ,:as => "register"
  match '/activate/:id', :to => 'activations#create', :as => "activate"
  match '/signup', :to => 'users#new', :as => "signup"
  match '/login', :to => 'user_sessions#new', :as => "login"
  match '/logout', :to => 'user_sessions#destroy', :as => "logout"
  match '/myaccount/:id', :to =>'users#edit', :as => "myaccount"


  namespace :admin do
    resources :users, :member => { :make_admin => :put, :remove_admin => :put}
  end

  root :to => 'index#index'

  match '/:controller(/:action(/:id))'


end
