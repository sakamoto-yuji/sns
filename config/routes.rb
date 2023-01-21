Rails.application.routes.draw do

  root "home#top"
  resources :posts, :users
  resource :likes, only: [:create, :destroy]

  get "login" => "users#login_form", as: :login_form
  post "login" => "users#login", as: :login
  post "logout" => "users#logout", as: :logout
 
  get "about" =>"home#about", as: :about

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
