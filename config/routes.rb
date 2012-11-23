Configurator::Application.routes.draw do
  resources :instructions
  resources :remote_apps do
    post :migrate, on: :member
  end
  
  post "consume_feed" => "webhooks#consume_feed"
  root :to => "instructions#index"
end
