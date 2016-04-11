Rails.application.routes.draw do
  root to: "feeds#index"

  resources :feeds


  match "/auth/:provider/callback", to: "sessions#create", via: [:get, :post]
end
