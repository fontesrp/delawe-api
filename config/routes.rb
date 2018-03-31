Rails.application.routes.draw do
  resources :tokens, only: :create
  resources :users, only: [:show, :update]
  resources :teams, only: :index
  resources :orders, except: [:show, :destroy]
  resources :transactions, only: [:index, :create]
end
