RotateRadio::Application.routes.draw do

  # home
  root :to => 'rotations#index'

  # all the oauth bullshit
  match '/auth/:provider/callback' => 'sessions#create', :as => :provider_auth
  
  resources :sessions
  match 'sign_out' => 'sessions#destroy', :via => :delete


  resources :rotations

end
