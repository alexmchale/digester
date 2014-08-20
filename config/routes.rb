Rails.application.routes.draw do

  resources :users do
    resource :instapaper_signin, module: "users"
  end

  resources :articles
  resources :user_sessions
  resources :feeds

  root "articles#index"

end
