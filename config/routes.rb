Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/', to: 'home#index'
      get '/filters', to: 'properties#filters'
      post '/contact-us', to: 'contact#contact_thank_you'
      post '/properties', to: 'properties#index'
      post '/property/:id', to: 'properties#show'
      post '/property/stay/:id', to: 'properties#stay'
      post '/property/avail/:id', to: 'properties#calendar_availability'
      # resources :properties, only: %i(index show)
    end
    resources :units, only: [:index, :show] do
      resources :stays, only: [:get]
    end
  end
end
