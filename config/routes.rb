Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    passwords: "users/passwords",
    confirmations: "users/confirmations"
      }


  root "home#top"
  resources :posts
  resources :relationships, only: [:create, :destroy]
  resources :users, :except => :create do
    member do
      get :following, :followers
    end
  
  end
  resource :likes, only: [:create, :destroy]


  get "login" => "users#login_form", as: :login_form
  post "login" => "users#login", as: :login
  post "logout" => "users#logout", as: :logout
 
  get "about" =>"home#about", as: :about

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
