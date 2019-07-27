Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'urls/top'
      post 'urls/url', to: 'urls#url'
      get 'urls/show'
    end
  end
  root to: 'pages#index'
  get '/index', to: 'pages#index', as: 'index'
  get '/not_found', to: 'pages#show', as: 'not_found'
  get '*unmatched_route', to: 'api/v1/urls#show'
  get '404', to: 'pages#show'
end
