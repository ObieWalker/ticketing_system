Rails.application.routes.draw do
  resources :users, except: [:new]
  resources :sessions, only: %i[create destroy]
  resources :requests
  resources :comments
end
