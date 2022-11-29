Rails.application.routes.draw do
  root "services#index"
  resources :services, only: [:index]
  
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

  resources :guideslol
  resources :guideslor
  resources :guidestft

end
