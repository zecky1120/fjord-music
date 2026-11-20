# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :sessions, only: %i[create destroy]
  resources :users, only: %i[index show]
  resources :pages, except: %i[index], param: :slug, path: ''
end
