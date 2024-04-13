Rails.application.routes.draw do
  devise_for :users, controllers: { 
    sessions: 'users/sessions' 
  }

  resources :stocks, only: [:index, :show]
  resources :user, only: [:index, :show]
  root 'stocks#index'
end
