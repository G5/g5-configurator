require 'resque/server'

Configurator::Application.routes.draw do
  mount G5Updatable::Engine => '/g5_updatable'
  mount G5Authenticatable::Engine => '/g5_auth'
  mount Resque::Server, :at => "/resque"

  resources :entries, only: [:index, :show]
  resources :tags, only: [:show]
  resources :instructions, only: [:index, :show, :new, :create]
  resources :apps, only: [:index, :show]
  resources :garden_updates, only: [:index, :create]

  post "consume_feed" => "webhooks#consume_feed"

  root :to => "entries#index"
end
