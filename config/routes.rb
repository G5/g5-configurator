Configurator::Application.routes.draw do
  resources :remote_apps do
    post :migrate, on: :member
  end
  root :to => 'remote_apps#index'
end
