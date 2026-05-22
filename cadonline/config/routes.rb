Rails.application.routes.draw do
  root "pages#index"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/signup", to: "registrations#new"
  post "/signup", to: "registrations#create"

  get "/about", to: "static#about"
  get "/terms", to: "static#terms"

  resource :account, only: [ :show ] do
    delete :destroy_data
  end

  resources :documents, only: [ :create, :show, :update, :destroy ] do
    member do
      patch :toggle_favorite
    end
  end
end
