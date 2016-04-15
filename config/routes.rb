Rails.application.routes.draw do
  root to: "home#index"

  resources :articles, only: [:index]

  resources :feeds, only: [:new, :create, :show] do
    resources :articles do
      member do
        get :bookmark
      end
    end

    member do
      get :refresh
      get :unsubscribe
    end
  end

  resources :bookmarked_articles, only: [:index, :create, :destroy]


  match "/auth/:provider/callback", to: "sessions#create", via: [:get, :post]
  match "/auth/failure", to: "sessions#failure", via: [:get, :post]
  match "/logout", to: "sessions#destroy", as: :logout, via: :delete
end
