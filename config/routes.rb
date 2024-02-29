# config/routes.rb
Rails.application.routes.draw do
  get 'analytics/index'
  root to: 'dashboards#show'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :businesses do
    resources :reviews
    resources :emailtemplates
    resources :campaigns
  end

  resources :notifications

  get 'analytics', to: 'analytics#index'
end
