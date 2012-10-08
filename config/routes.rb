Configurator::Application.routes.draw do
  resources :remote_apps, path: "/remote-app/"
    root :to => 'remote_apps#index'
end
