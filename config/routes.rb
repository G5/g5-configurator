Configurator::Application.routes.draw do
  resources :remote_apps do
    get :migrate, on: :member
  end
  root :to => 'remote_apps#index'
end
