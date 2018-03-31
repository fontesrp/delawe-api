Rails.application.routes.draw do

  resources :tokens, only: [:create]
  resources :users, only: [:show, :index, :update]
end
