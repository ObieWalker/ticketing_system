Rails.application.routes.draw do
  resources :users
  resources :sessions, only: [:create, :destroy]
  resources :requests
  resources :comments
end
