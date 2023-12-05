Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v0 do
      # get "/merchants/find_all", to: "merchants_lookup#index"
      # get "/merchants/find", to: "merchants_lookup#show"
      # get "/items/find_all", to: "items_lookup#index"
      # get "/items/find", to: "items_lookup#show"
      resources :markets, only: [:index, :show] do
        resources :vendors, only: [:index]
      end

      resources :vendors, only: [:index, :show, :create, :destroy] do
        # resources :merchant, only: [:index], controller: "item_merchants"
      end
    end
  end
end
