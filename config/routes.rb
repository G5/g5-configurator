Configurator::Application.routes.draw do
  resources :instructions
  resources :remote_apps do
    post :migrate, on: :member
  end
  
  post 'webhook' => 'webhook#index'
  root :to => 'instructions#index'
end
