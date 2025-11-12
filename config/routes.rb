Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  root "posts#index"

  resources :posts do
    resources :comments, shallow: true # Adds /comments/:id for show, edit, update, destroy
    get 'comments_drawer', on: :member # /posts/:id/comments_drawer
    post 'toggle_like', on: :member
  end

  get 'profile', to: 'profile#edit'
  patch 'profile', to: 'profile#update'
  put 'profile', to: 'profile#update'

  resources :users, only: [:show]
end
