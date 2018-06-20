Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'main#index'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do

      resources :websites, only: [:index, :show] do
        collection do
          get ':id/categories', to: 'websites#get_categories'
          get ':id/categories/:category_id', to: 'websites#get_category_with_articles'
          get ':id/articles', to: 'websites#get_articles'
          get ':id/articles/:article_id', to: 'websites#get_category_article'
        end
      end
      resources :categories, only: [:index, :show]
      resources :articles, only: [:index, :show]
      resources :articles, only: [:index, :show]
    end
  end
end
