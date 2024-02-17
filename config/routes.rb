Rails.application.routes.draw do
  root to: 'dashboards#show'
  # In config/routes.rb
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }


  # root "articles#index"
  resources :businesses do
    resources :reviews
    resources :emailtemplates
    resources :campaigns
  end

  resources :notifications
end
