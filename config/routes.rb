Rails.application.routes.draw do
  devise_for :users, controllers: { 
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :stocks, only: [:index, :show]
  resources :users

  get 'admins', to: 'users_roles#admins'
  get 'traders', to: 'users_roles#traders'
  get 'new_users', to: 'users_roles#new_users'
  get 'pending_traders', to: 'users_roles#pending_traders'

  root 'stocks#index'
  resources :transactions, only: [:new, :create, :show]


end
