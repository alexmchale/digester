Rails.application.routes.draw do

  resources :users
  resources :articles
  resources :user_sessions
  resources :feeds

  root "articles#index"

end
