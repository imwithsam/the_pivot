Rails.application.routes.draw do
  root to: "static_pages#index"

  namespace :admin do
    resources :events, only: [:index, :new, :create, :edit, :update]
    resources :orders, only: [:index, :show, :update]

    get "/",           to: "admins#index"
    get "/dashboard",  to: "admins#index"
  end

  get "/admin/ordered-orders",   to: "admin/orders#index_ordered"
  get "/admin/paid-orders",      to: "admin/orders#index_paid"
  get "/admin/cancelled-orders", to: "admin/orders#index_cancelled"
  get "/admin/completed-orders", to: "admin/orders#index_completed"

  resources :events, only: [:index]
  resources :categories, param: :slug, only: [:show]
  resources :orders, only: [:index, :show, :update]
  resources :cart_items, only: [:create, :update, :destroy]
  resources :addresses, only: [:new, :update, :create]


  get "/dashboard",    to: "users#show"

  patch "/account",    to: "users#update"
  post "/account",     to: "users#create"
  get "/account/new",  to: "users#new"
  get "/account/edit", to: "users#edit"
  get "/vendors",      to: "users#index"

  get "/cart",         to: "cart_items#index"

  get "/login",        to: "sessions#new"
  post "/login",       to: "sessions#create"
  delete "/logout",    to: "sessions#destroy"

  resources :charges,  only: [:create]

  post "twilio/connect_customer" => "twilio#connect_customer"

  namespace :users, path: ":vendor", as: :vendor do
    resources :events, only: [:show, :new, :create, :edit, :update, :destroy]
    resources :event_orders, only: [:destroy]
  end

  get "/:vendor", to: "users/events#index"
end
