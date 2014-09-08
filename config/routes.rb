Rails.application.routes.draw do

  get 'instapaper_bookmarks/index'

  resources :users do
    resource :instapaper_signin, module: "users"
    resources :open_articles
  end

  resources :articles
  resources :user_sessions
  resources :feeds

  get "/instapaper_bookmarks", to: "instapaper_bookmarks#index"

  root "articles#index"

end
