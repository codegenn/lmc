Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get "sitemap.xml" => "sitemaps#index", :format => "xml", :as => :sitemap
  get "sitemaps/static-index.xml" => "sitemaps#index_page", :format => "xml", :as => :sitemap_static
  match "/404", to: "errors#not_found", via: :all
  match "/422", to: "errors#unacceptable", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  scope "(:locale)", :locale => /en|vi/ do
    get 'store/index'
    get 'thoi-trang-ton-vinh-phu-nu', to: "store#about"
    get 'lien-he', to: "store#find_us"
    get 'policy', to:"store#policy"
    get 'store/ping'
    get 'privacy', to:"store#privacy"
    root 'store#index', as: 'store'
    resources :products, only: [:index, :show]
    resources :subscribers, only: [:create]
    resources :foundations, only: [:index, :show]
    resources :jobs, only: [:index, :show]
    resources :applications, only: [:create]
    resources :partners, only: [:create]
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
