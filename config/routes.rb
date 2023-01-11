Rails.application.routes.draw do
  get "login" => "users#login_form"
  post "login" => "users#login"
  post "logout" => "users#logout"

  get 'users/index' => "users#index"
  get "users/:id" => "users#show"
  get "signup" => "users#new"
  post "users/create" => "users#create"
  get "users/:id/edit" => "users#edit"
  post "users/:id/update" => "users#update"
  delete "users/:id/destroy" => "users#destroy"
  
  delete "posts/:id/destroy" => "posts#destroy" 
  get "posts/index" =>"posts#index"
  get "posts/new" =>"posts#new"
  get "posts/:id" =>"posts#show"
  post "posts/create" =>"posts#create"
  get "/" =>"home#top"
  get "about" =>"home#about"
  get "posts/:id/edit" => "posts#edit"
  post "posts/:id/update" => "posts#update"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
