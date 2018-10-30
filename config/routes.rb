Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  # ActiveAdmin.routes(self)

  # root :to => redirect('/admin')
  resources :apidocs, only: [:index]
  get '/api' => redirect('/swagger/dist/index.html?url=/apidocs')

  authenticate :admin_user do
    mount Sidekiq::Web, at: '/sidekiq'
  end

  namespace :callbacks do
    namespace :aweber do
      get "/auth_account", to: "accounts#auth_account"
    end
  end

  resources :suppression_lists, only: [:index] do
    collection do
      get '/download', to: 'suppression_lists#download'
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
          post ':id/unsubscribe_user', to: 'formsites#unsubscribe_user', as: 'unsubscribe_user'
          get ':id/setup', to: 'formsites#setup', as: 'setup'
          get ':id/build', to: 'formsites#build', as: 'build'

          get ':id/questions', to: 'formsites#get_formsite_questions'
          get ':id/questions_by_position/:position', to: 'formsites#get_formsite_question'

        end
        resources :questions, only: [:index] do
          member do
            post "create_answer", to: "formsites_questions#create_answer"
          end
        end
        end

      resources :leadgen_rev_sites, only: [:index, :show] do
        collection do
          post ':id/add_user', to: 'leadgen_rev_sites#add_leadgen_rev_site_user', as: 'add_user'
          post ':id/unsubscribe_user', to: 'leadgen_rev_sites#unsubscribe_user', as: 'unsubscribe_user'
          get ':id/setup', to: 'leadgen_rev_sites#setup', as: 'setup'
          get ':id/build', to: 'leadgen_rev_sites#build', as: 'build'

          get ':id/questions', to: 'leadgen_rev_sites#get_leadgen_rev_site_questions'
          get ':id/questions_by_position/:position', to: 'leadgen_rev_sites#get_leadgen_rev_site_question'
          get ':id/rebuild_old', to: 'leadgen_rev_sites#rebuild_old', as: 'rebuild_old'
          get ':id/config', to: 'leadgen_rev_sites#get_config', as: 'get_config'
          get ':id/categories', to: 'leadgen_rev_sites#get_categories'
          get ':id/product_cards', to: 'leadgen_rev_sites#get_product_cards'
          get ':id/categories/:category_id', to: 'leadgen_rev_sites#get_category_with_articles'
          get ':id/articles', to: 'leadgen_rev_sites#get_articles'
          get ':id/product_cards', to: 'leadgen_rev_sites#get_product_cards'
          get ':id/articles/:article_id', to: 'leadgen_rev_sites#get_category_article'
        end
        resources :questions, only: [:index] do
          member do
            post "create_answer", to: "leadgen_rev_sites_questions#create_answer"
          end
        end
      end
      resources :categories, only: [:index, :show, :create]
      resources :articles, only: [:index, :show, :create]
      resources :api_users, only: [:show, :create, :update]
    end
  end
end
