Rails.application.routes.draw do
  resources :cart_items
  post '/login', to: 'sessions#create'
  get '/auth',to: 'users#show'
  delete '/logout',to: 'sessions#destroy'
  resources :carts
  resources :products
  resources :testimonials
  resources :admins, only: [:create, :update, :destroy]
  resources :users
end
