Rails.application.routes.draw do
  devise_for :users,
  controllers: {
    registrations: "users/registrations",
    confirmations: "users/confirmations"
  }

  authenticate :user do
    resource :dashboard, only: [ :show, :edit, :update ], controller: "dashboard" do
      get :share
    end
    resource :github_import, only: :create

    namespace :dashboard do
      resources :favorite_links, only: [ :new, :create, :edit, :update, :destroy ]
      resources :experiences, only: [ :new, :create, :edit, :update, :destroy ]
      resources :posts, param: :id
      resources :subscribers, only: :destroy
      resource :draft, only: [] do
        get :link
        get :experience
      end
    end
  end

  resource :onboarding, only: [ :show, :update ] do
    get :check_username, on: :collection
  end

  # public confirm email page
  get "/confirmation-sent", to: "static#confirmation_sent", as: :confirmation_sent

  # public confirm subscription page
  get "/:username/confirmation-sent", to: "static#subscription_sent", as: :subscription_sent

  get "up" => "rails/health#show", as: :rails_health_check

  # Policies
  get "/privacy", to: "pages#privacy", as: :privacy
  get "/terms", to: "pages#terms", as: :terms

  constraints ->(req) { User.custom_domain?(req.host) } do
    get "/", to: "profiles#show", as: :custom_domain_root
    get "/feed", to: "rss#user", as: :custom_domain_feed, defaults: { format: :rss }
    get "/links/:id/click", to: "public_links#click", as: :custom_domain_link_click
    post "/subscribe", to: "subscriptions#subscribe", as: :custom_domain_subscribe
    get "/posts/:id", to: "public_posts#show", as: :custom_domain_post
    get "/:token/confirm", to: "subscriptions#confirm", as: :custom_domain_confirm
    get "/:token/cancel", to: "subscriptions#cancel", as: :custom_domain_cancel
  end

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#index"

  get "/:username/feed", to: "rss#user", as: :user_feed, defaults: { format: :rss }
  get "/:username/links/:id/click", to: "public_links#click", as: :public_link_click
  post "/:username/subscribe", to: "subscriptions#subscribe", as: :new_subscription
  get "/:username/:token/confirm", to: "subscriptions#confirm", as: :confirm_subscription
  get "/:username/:token/cancel", to: "subscriptions#cancel", as: :cancel_subscription

  get "/:username", to: "profiles#show", as: :public_profile,
    constraints: ->(req) { User.public_username?(req.params[:username]) }

  # posts
  get "/:username/posts/:id", to: "public_posts#show", as: :public_post
end
