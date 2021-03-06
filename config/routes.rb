# frozen_string_literal: true

Rails.application.routes.draw do
  root 'ui/challenges#index'

  devise_for :users,
             class_name: 'Repo::User',
             path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register', edit: 'profile' }

  resources :challenges, only: %i[index show], controller: 'ui/challenges' do
    resources :members, only: %i[create destroy], controller: 'ui/members'
  end
  resources :tasks, only: :show, controller: 'ui/tasks' do
    resources :submissions, only: %i[create update destroy], controller: 'ui/submissions'
  end
  resources :assessments, only: %i[new create edit update], controller: 'ui/assessments'

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
      resources :tasks, except: %i[destroy] do
        resources :submissions, only: %i[index destroy]
        resources :criteria, except: :show
      end
    end
    resources :judges, only: :index
    resources :users, except: %i[show]
    resources :taxonomies, except: %i[destroy] do
      resources :taxons, except: %i[show]
    end
  end
end
