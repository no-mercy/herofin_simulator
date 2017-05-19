Rails.application.routes.draw do
  mount Crono::Web, at: '/crono'
  root to: 'users#index'
  resources :users, except: :update
  post 'transfer_money', to: 'banking_operations#transfer_money'
end
