require 'resque/server'

Configurator::Application.routes.draw do
  mount Resque::Server, :at => "/resque"

  resources :instructions
  resources :remote_apps do
    post :migrate, on: :member
  end
  
  post "consume_feed" => "webhooks#consume_feed"
  root :to => "instructions#index"
end
