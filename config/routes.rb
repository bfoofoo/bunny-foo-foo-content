Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'main#index'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do

      resources :websites, only: [:index, :show]
      resources :categories, only: [:index, :show]
      resources :articles, only: [:index, :show]
      resources :articles, only: [:index, :show]
    end
  end
end
