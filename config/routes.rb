Rails.application.routes.draw do
  devise_for :user, :path => '', :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register" }

  namespace :admin do
    resources :reviews do
      collection do
        get :new_csv
        post :import_csv
        get :delete_all
      end
    end
    resources :recommendations
        
    root to: "reviews#index"
  end

  namespace :api do
    namespace :v1 do
      get '/', to: 'home#index'
      get '/filters', to: 'properties#filters'
      post '/contact-us', to: 'contact#contact_thank_you'
      post '/properties', to: 'properties#index'
      post '/property/:id', to: 'properties#show'
      post '/property/stay/:id', to: 'properties#stay'
      post '/property/availability/:id', to: 'properties#calendar_availability'
      # resources :properties, only: %i(index show)
    end
    resources :units, only: [:index, :show] do
      resources :stays, only: [:get]
    end
  end
end
