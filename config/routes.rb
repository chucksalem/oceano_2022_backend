Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/', to: 'home#index'
      resources :properties, only: %i(index show)
    end
    resources :units, only: [:index, :show] do
      resources :stays, only: [:get]
    end
  end
end
