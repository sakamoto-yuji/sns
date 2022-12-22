Rails.application.routes.draw do
  get 'users/index' => "users#index"
  get "users/:id" => "users#show"
  get "signup" => "users#new"
  post "users/create" => "users#create"
  get "users/:id/edit" => "users#edit"
  post "users/:id/update" => "users#update"
  get "users/:id/destroy" => "users#destroy"
  
  get "posts/:id/destroy" => "posts#destroy" 
  get "posts/index" =>"posts#index"
  get "posts/new" =>"posts#new"
  get "posts/:id" =>"posts#show"
  post "posts/create" =>"posts#create"
  get "top" =>"home#top"
  get "about" =>"home#about"
  get "posts/:id/edit" => "posts#edit"
  post "posts/:id/update" => "posts#update"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
