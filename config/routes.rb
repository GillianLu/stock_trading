Rails.application.routes.draw do
  devise_for :users, controllers: { 
    sessions: 'users/sessions' 
  }

  resources :stocks, only: [:index, :show]
  resources :user
  root 'stocks#index'
end
