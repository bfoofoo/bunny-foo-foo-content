Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root :to => redirect('/admin')
  resources :apidocs, only: [:index]
  get '/api' => redirect('/swagger/dist/index.html?url=/apidocs')

  namespace :callbacks do
    namespace :aweber do
      get "/auth_account", to: "accounts#auth_account"
    end
  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do

      resources :websites, only: [:index, :show] do
        collection do
          get ':id/setup', to: 'websites#setup', as: 'setup'
          get ':id/build', to: 'websites#build', as: 'build'
          get ':id/rebuild_old', to: 'websites#rebuild_old', as: 'rebuild_old'
          get ':id/config', to: 'websites#get_config', as: 'get_config'
          get ':id/categories', to: 'websites#get_categories'
          get ':id/product_cards', to: 'websites#get_product_cards'
          get ':id/categories/:category_id', to: 'websites#get_category_with_articles'
          get ':id/articles', to: 'websites#get_articles'
          get ':id/product_cards', to: 'websites#get_product_cards'
          get ':id/articles/:article_id', to: 'websites#get_category_article'
        end
      end

      resources :formsites, only: [:index, :show] do
        collection do
          post ':id/add_user', to: 'formsites#add_formsite_user', as: 'add_user'
          get ':id/setup', to: 'formsites#setup', as: 'setup'
          get ':id/build', to: 'formsites#build', as: 'build'

          get ':id/questions', to: 'formsites#get_formsite_questions'

        end
        resources :questions, only: [:index] do
          member do
            post "create_answer", to: "formsites_questions#create_answer"
          end
        end
      end
      resources :categories, only: [:index, :show, :create]
      resources :articles, only: [:index, :show, :create]
      resources :api_users, only: [:index, :show, :create, :update]
    end
  end
end
