require 'resque/server'

Configurator::Application.routes.draw do
  mount G5Authenticatable::Engine => '/g5_auth'
  mount Resque::Server, :at => "/resque"

  resources :entries, only: [:index, :show]
  resources :tags, only: [:show]
  resources :instructions, only: [:index, :show, :new, :create]
  resources :apps, only: [:index, :show]

  post "consume_feed" => "webhooks#consume_feed"

  root :to => "entries#index"
end
