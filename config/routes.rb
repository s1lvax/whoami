Rails.application.routes.draw do
  devise_for :users,
  controllers: {
    registrations: "users/registrations",
    confirmations: "users/confirmations"
  }

  authenticate :user do
    resource :dashboard, only: [ :show, :edit, :update ], controller: "dashboard"
  end

  namespace :dashboard do
    resources :favorite_links, only: [ :new, :create, :destroy ]
    resources :experiences, only: [ :new, :create, :destroy ]
    resources :posts, param: :id
  end

  resource :onboarding, only: [ :show, :update ] do
    get :check_username, on: :collection
  end

  # public confirm email page
  get "/confirmation-sent", to: "static#confirmation_sent", as: :confirmation_sent

  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "dashboard#show"

  reserved = %w[users rails active_storage assets packs system onboarding dashboard posts links admin]
  username = /\A[a-z0-9]{3,30}\z/

  get "/:username", to: "profiles#show", as: :public_profile,
    constraints: ->(req) {
      u = req.params[:username].to_s
      u.match?(username) && !reserved.include?(u)
    }

  # posts
  get "/:username/posts/:id", to: "public_posts#show", as: :public_post
end
