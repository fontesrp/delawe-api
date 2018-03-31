Rails.application.routes.draw do

  resources :tokens, only: :create

  resources :users, only: [:show, :update] do
    resources :teams, only: :index
  end
end
