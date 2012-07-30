RotateRadio::Application.routes.draw do

  # home
  root :to => 'heavy_rotations#index'

  # all the oauth bullshit
  match '/auth/:provider/callback', to: 'sessions#create'
  
  resources :sessions
  resources :heavy_rotations

end
