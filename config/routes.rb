Rails.application.routes.draw do

  resources :articles
  
  get '/search', to: 'application#search'
  get '/search_safe', to: 'application#safe_search'

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root :to => "application#index"
end
