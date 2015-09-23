Rails.application.routes.draw do
  root 'home#index'

  resources :accomodations, controller: :properties, only: [:index, :show]

  PagesController.action_methods.each do |action|
    get "/#{action}".dasherize, to: "pages##{action}", as: "#{action}_page"
  end

  namespace :api do
    resources :units, only: [:index, :show] do
      resources :stays, only: [:get]
    end
  end
end
