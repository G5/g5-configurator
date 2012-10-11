Configurator::Application.routes.draw do
  resources :remote_apps do
    post :migrate, on: :member
  end
  post 'webhook' => 'webhook#index'
  root :to => 'remote_apps#index'
end
