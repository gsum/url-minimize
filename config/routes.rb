Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'urls/top'
      get 'urls/url'
      get 'urls/show'
    end
  end
  root to: 'pages#index'
  get 'pages/index'
end
