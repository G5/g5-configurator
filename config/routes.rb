Configurator::Application.routes.draw do
  resources :remote_apps
  post 'webhook' => 'webhook#index'
  root :to => 'remote_apps#index'
end
