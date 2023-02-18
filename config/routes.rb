Rails.application.routes.draw do
  
  root "services#index"
  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' }
  resources :users, :only => [:show]

  resources :services, only: [:index]
  resources :guides
  resources :reviews
  
  get "lol_review", to: "lol#review"
  get "lol_review_player", to: "lol#apicall"
  get "lol_leaderboard", to: "lol#leaderboard"
  get "lol_leaderboard_queue", to: "lol#leaderboardAPI"

  get "lor_review", to: "lor#review"
  get "lor_review_player", to: "lor#apicall"
  get "lor_leaderboard", to: "lor#leaderboard"
  get "lor_leaderboard_queue", to: "lor#leaderboardAPI"

  
  get "tft_review", to: "tft#review"
  get "tft_review_player", to: "tft#apicall"
  get "tft_leaderboard", to: "tft#leaderboard"
  get "tft_leaderboard_queue", to: "tft#leaderboardAPI"
  get "tft_addToSpreadsheet", to: "tft#addToSpreadsheet"

  get "guides_addToDocs", to: "guides#addToDocs"


end
