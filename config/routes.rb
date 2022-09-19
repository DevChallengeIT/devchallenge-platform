# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  root 'ui/challenges#index'

  devise_for :users,
             class_name:  'Repo::User',
             path:        '',
             path_names:  { sign_in: 'login', sign_out: 'logout', sign_up: 'register', edit: 'profile' },
             controllers: { omniauth_callbacks: 'callbacks', registrations: 'registrations' }

  resources :challenges, only: %i[index show], controller: 'ui/challenges' do
    get :terms_and_conditions
    resources :members, only: %i[create destroy], controller: 'ui/members'
  end

  resources :tasks, only: :show, controller: 'ui/tasks' do
    resources :submissions, only: %i[create update destroy], controller: 'ui/submissions', shallow: true do
      resource :assessments, only: %i[new create edit update], controller: 'ui/assessments'
    end
  end

  namespace :admin do
    root 'dashboard#index'

    concern :manage_taxonomies do
      collection do
        get '/taxonomies', to: 'taxonomy_repo#index'
        post '/taxonomies/:taxonomy_id', to: 'taxonomy_repo#create'
        delete '/taxonomies/:taxonomy_repo_id', to: 'taxonomy_repo#destroy'
      end
    end

    resources :challenges, except: %i[destroy], concerns: :manage_taxonomies, repo: :challenges do
      resources :members, except: :show
      resources :tasks do
        resource :results, only: :show
        resources :submissions, only: %i[index new create edit update destroy]
        resources :criteria, except: :show
      end
    end
    resources :judges, only: :index
    resources :users, except: %i[show] do
      post :log_in_as
    end
    resources :taxonomies, except: %i[destroy] do
      resources :taxons, except: %i[show]
    end
  end

  mount Sidekiq::Web, at: '/sidekiq'
end
