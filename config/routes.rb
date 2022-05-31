Rails.application.routes.draw do
  root "services#index"
  resources :services, only: [:index]
  resources :lol, only: [:index]
  resources :lor, only: [:index]
  resources :tft, only: [:index]

end
