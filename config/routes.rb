Rails.application.routes.draw do

  get 'instapaper_bookmarks/index'

  resources :users do
    resource :instapaper_signin, module: "users"
  end

  resources :articles
  resources :user_sessions
  resources :feeds

  get "/instapaper_bookmarks", to: "instapaper_bookmarks#index"

  root "articles#index"

end
