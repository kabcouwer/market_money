Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v0 do
      resources :markets, only: [:index, :show] do
        resources :vendors, module: 'markets', only: [:index]
      end

      resources :vendors, only: [:show, :new, :create, :update, :destroy] do
        resources :markets, module: 'vendors', only: [:index]
      end
    end
  end
end
