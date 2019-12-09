Rails.application.routes.draw do
  get 'store/index'
  get 'store/about'
  root 'store#index', as: 'store'
  resources :products, only: [:index, :show]
  resources :blogs, only: [:index, :show]
end
