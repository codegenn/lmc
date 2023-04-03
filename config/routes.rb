Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "order_detail", to: "fundiin#order_detail"
      post "update_payment", to: "fundiin#update_payment"
      post "update_tags", to: "fundiin#update_tags"
      post "update_transaction", to: "spp#noti_transaction_status"
      post "check_transaction", to: "spp#check_transaction"
      get "vnp-ipn-transaction", to: "vnpay#vnpay_ipn"
    end
    namespace :v2 do
      get "product", to: "api#product"
    end
  end
  get '/health_check', to: proc { [200, {}, ['success']] }
  root to: "store#index"
  # devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  devise_for :users,
    controllers: { registrations: 'registrations', omniauth_callbacks: "users/omniauth_callbacks"}
  # devise_for :users, controllers: { registrations: 'registrations' }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get "sitemap.xml" => "sitemaps#index", :format => "xml", :as => :sitemap
  get "sitemaps/static-index.xml" => "sitemaps#index_page", :format => "xml", :as => :sitemap_static
  match "/404", to: "errors#not_found", via: :all
  match "/422", to: "errors#unacceptable", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  post 'destroy_item/:id', to: "line_items#destroy_item"
  scope "(:locale)", :locale => /en|vi/ do
    get "demo-fittingroom", to: "fittingroom#index"
    post "demo-login", to: "fittingroom#login"
    get 'vnpay-fallback', to: "orders#fallback"
    get 'store/index'
    get 'thoi-trang-ton-vinh-phu-nu', to: "store#about"
    get 'lien-he', to: "store#find_us"
    get 'policy', to:"store#policy"
    get "huong-dan-mua-hang", to: "store#privacy_buy"
    get "quy-dinh-thanh-toan-va-van-chuyen", to: "store#privacy_payment"
    get "shipping", to: "store#deliver"
    get 'store/ping'
    get 'privacy', to:"store#privacy"
    root 'store#index', as: 'store'
    get 'partners/sign-in', to: "partners#sign_in"
    get 'partners/sign-up', to: "partners#sign_up"
    get 'partners/admin', to: "partners#admin"
    resources :products, only: [:index, :show]
    resources :subscribers, only: [:create]
    resources :foundations, only: [:index, :show]
    resources :jobs, only: [:index, :show]
    resources :applications, only: [:create]
    resources :partners, only: [:index, :create]
    resources :messages, only: [:create]
    resources :carts, only: [:show, :update]
    resources :line_items, only: [:create, :update, :destroy]
    resources :orders, only: [:index, :new, :create]
    resources :search, only: [:index]
    resources :favorites, only: [:update]
    resources :trackings, only: [:index]
    resources :stocks, only: [] do
      get :show, on: :collection
    end
  end
end


