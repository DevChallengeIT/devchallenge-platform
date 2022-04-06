# frozen_string_literal: true

Rails.application.routes.draw do
  root 'ui/home#index'

  devise_for :users,
             class_name: 'Repo::User',
             path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register', edit: 'profile' }

  namespace :admin do
    root 'dashboard#index'

    resources :challenges, except: %i[show destroy]
    resources :taxonomies, only: %i[index] do
      resources :taxons, except: %i[show]
    end
  end
end
