Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root :to => redirect('/admin')

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do

      resources :websites, only: [:index, :show] do
        collection do
          get ':id/setup', to: 'websites#setup', as: 'setup'
          get ':id/build', to: 'websites#build', as: 'build'
          get ':id/categories', to: 'websites#get_categories'
          get ':id/categories/:category_id', to: 'websites#get_category_with_articles'
          get ':id/articles', to: 'websites#get_articles'
          get ':id/articles/:article_id', to: 'websites#get_category_article'
        end
      end

      resources :formsites, only: [:index, :show] do
        collection do
          post ':id/add_user', to: 'formsites#add_formsite_user', as: 'add_user'
          get ':id/questions', to: 'formsites#get_formsite_questions'
          get ':id/setup', to: 'formsites#setup', as: 'setup'
          get ':id/build', to: 'formsites#build', as: 'build'
        end
      end
      resources :categories, only: [:index, :show]
      resources :articles, only: [:index, :show]
    end
  end
end
