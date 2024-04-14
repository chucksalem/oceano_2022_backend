require 'sidekiq'
require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :user, :path => '', :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register" }

  namespace :admin do
    resources :blogs
  
    resources :reviews do
      collection do
        get :new_csv
        post :import_csv
        get :delete_all
      end
    end
    resources :recommendations
    resources :deals
    resources :announcements

    root to: "reviews#index"
  end

  namespace :api do
    namespace :v1 do
      devise_scope :user do
        post '/login', to: 'sessions#create'
        delete '/logout', to: 'sessions#destroy'
      end
      get '/', to: 'home#index'
      get '/deals', to: 'home#deals'
      get '/filters', to: 'properties#filters'
      post '/contact-us', to: 'contact#contact_thank_you'
      post '/properties', to: 'properties#index'
      post '/property/:id', to: 'properties#show'
      post '/property/stay/:id', to: 'properties#stay'
      post '/property/availability/:id', to: 'properties#calendar_availability'
      # resources :properties, only: %i(index show)
      get '/announcements', to: 'announcements#index'
      resources :triggers, only: :create
      resources :blogs

      resources :subscriptions, only: [:new, :create]

    end
    resources :units, only: [:index, :show] do
      resources :stays, only: [:get]
    end
  end

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

end
