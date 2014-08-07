Rails.application.routes.draw do

  resources :users
  resources :articles
  resources :user_sessions

  root "articles#index"

end
