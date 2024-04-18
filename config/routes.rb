Rails.application.routes.draw do
  devise_for :users, controllers: { 
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  root 'stocks#index'

  resources :stocks, only: [:index] do
    collection do
      get '/:symbol', to: 'stocks#show', as: 'stock'
    end
  end

  resources :users

  get 'admins', to: 'users_roles#admins'
  get 'traders', to: 'users_roles#traders'
  get 'new_users', to: 'users_roles#new_users'
  get 'pending_traders', to: 'users_roles#pending_traders'

  resources :transactions, only: [:create, :show] do
    collection do
      get 'buy', to: 'transactions#new', as: 'buy'
      post 'buy', to: 'transactions#buy', as: 'buy_create'
      get 'sell', to: 'transactions#new', as: 'sell'
      post 'sell', to: 'transactions#sell', as: 'sell_create'
    end
  end
end
