Rails.application.routes.draw do
  devise_for :admin_users

  resources :apidocs, only: [:index]
  get '/api' => redirect('/swagger/dist/index.html?url=/apidocs')
  mount HealthMonitor::Engine, at: '/'

  authenticate :admin_user do
    mount Sidekiq::Web, at: '/sidekiq'
  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :message_schedules, only: [] do
        member do
          post 'schedule_sending'
          post 'cancel'
          post 'send_now'
        end
      end

      resources :websites, only: [:index, :show] do
        member do
          post 'add_user', to: 'websites#add_formsite_user', as: 'add_user'
          post 'unsubscribe_user', to: 'websites#unsubscribe_user', as: 'unsubscribe_user'
          get 'questions', to: 'websites#get_website_questions'
          get 'questions_by_position/:position', to: 'websites#get_website_question'
          get 'setup'
          get 'build'
          get 'rebuild_old'
          get 'config', to: 'websites#get_config', as: 'get_config'
          get 'categories', to: 'websites#get_categories'
          get 'product_cards', to: 'websites#get_product_cards'
          get 'categories/:category_id', to: 'websites#get_category_with_articles'
          get 'articles', to: 'websites#get_articles'
          get 'articles/:article_id', to: 'websites#get_category_article'
        end
        resources :questions, only: [:index] do
          member do
            post "create_answer", to: "websites_questions#create_answer"
          end
        end
      end

      resources :formsites, only: [:index, :show] do
        member do
          post 'add_user', to: 'formsites#add_formsite_user', as: 'add_user'
          post 'unsubscribe_user'
          get 'setup'
          get 'build'

          get 'questions', to: 'formsites#get_formsite_questions'
          get 'questions_by_position/:position', to: 'formsites#get_formsite_question'

        end
        resources :questions, only: [:index] do
          member do
            post "create_answer", to: "formsites_questions#create_answer"
          end
        end
        end

      resources :leadgen_rev_sites, only: [:index, :show] do
        member do
          post 'add_user', to: 'leadgen_rev_sites#add_leadgen_rev_site_user', as: 'add_user'
          post 'unsubscribe_user'
          get 'setup'
          get 'build'
          get 'rebuild_old'
          get 'config', to: 'leadgen_rev_sites#get_config', as: 'get_config'
          get 'categories', to: 'leadgen_rev_sites#get_categories'
          get 'question_by_position', to: 'leadgen_rev_sites#get_question_by_position'
        end
        resources :questions, only: [:index, :show] do
          member do
            post "create_answer", to: "leadgen_rev_sites_questions#create_answer"
          end
        end
        resources :articles, only: [:index, :show]
        resources :product_cards, only: [:index, :show]
        resources :categories, only: [] do
          resources :articles, only: [:index, :show]
        end
      end
      resources :categories, only: [:index, :show, :create] do
        resources :articles, only: [:index, :show]
      end
      resources :articles, only: [:index, :show, :create]
      resources :api_users, only: [:show, :create, :update]
    end
  end
end
