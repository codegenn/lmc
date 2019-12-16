Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get 'store/index'
  get 'store/about'
  get 'store/find_us'
  root 'store#index', as: 'store'
  resources :products, only: [:index, :show]
  resources :blogs, only: [:index, :show]
end
