Rails.application.routes.draw do
  root to: "home#index"

  resources :feeds do
    member do
      get :refresh
    end
  end


  match "/auth/:provider/callback", to: "sessions#create", via: [:get, :post]
  match "/auth/failure", to: "sessions#failure", via: [:get, :post]
  match "/logout", to: "sessions#destroy", as: :logout, via: :delete
end
