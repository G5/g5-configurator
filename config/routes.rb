Configurator::Application.routes.draw do
  resources :remote_apps
    root :to => 'remote_apps#index'
end
