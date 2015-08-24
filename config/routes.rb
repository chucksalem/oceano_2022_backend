Rails.application.routes.draw do
  root 'home#index'

  get  '/accomodations' => 'property#index'
  get  '/property/:id'  => 'property#view'

  PagesController.action_methods.each do |action|
    get "/#{action}", to: "pages##{action}", as: "#{action}_page"
  end

  namespace :api do
    resources :units, only: [:index, :show] do
      resources :stays, only: [:get]
    end
  end
end
