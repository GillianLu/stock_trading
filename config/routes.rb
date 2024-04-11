Rails.application.routes.draw do
  devise_for :users
  resources :stocks, only: [:index, :show]
  root 'stocks#index'
end
