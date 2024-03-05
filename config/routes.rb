# config/routes.rb
Rails.application.routes.draw do
  authenticate :user do
    get '/reviews', to: 'reviews#index', as: 'reviews'
  end
  get 'analytics/index'
  root to: 'dashboards#show'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :businesses do
    resources :emailtemplates
    resources :campaigns
  end

  resources :notifications

  get 'analytics', to: 'analytics#index'
end
