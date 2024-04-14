Rails.application.routes.draw do
  devise_for :users

  resources :stocks

  root 'stocks#index'
  resources :transactions, only: [:new, :create, :show]


end
