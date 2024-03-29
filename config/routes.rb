RotateRadio::Application.routes.draw do

  # home
  root :to => 'defaults#index'

  # all the oauth bullshit
  match '/auth/:provider/callback' => 'sessions#create', :as => :provider_auth
  
  resources :sessions
  match 'sign_out' => 'sessions#destroy', :via => :delete

  resources :artists
  
  resources :users do
    resources :rotations do
      post 'refresh', :on => :collection
    end
  end

  resources :rotations do
    resources :artists
  end


end
