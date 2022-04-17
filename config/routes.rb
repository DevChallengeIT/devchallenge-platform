# frozen_string_literal: true

Rails.application.routes.draw do
  root 'ui/home#index'

  devise_for :users,
             class_name: 'Repo::User',
             path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register', edit: 'profile' }

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
    end
    resources :tasks, except: %i[destroy]
    resources :judges, only: :index

    resources :taxonomies, except: %i[destroy] do
      resources :taxons, except: %i[show]
    end
  end
end
