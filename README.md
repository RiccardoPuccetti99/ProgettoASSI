# README

How to test the applicazion:
* You need a riot account to get a riot api key
* You need google oauth credentials to obtain the keys
* You can use this command EDITOR="code --wait" bin/rails credentials:edit to change the keys
* Now you can use all the riot api related functionalities
* The test the lol, lor and tft reviews, you can take a random username from the leaderboard and search with the correct country
* You need to log in with a google account via oauth to test google docs and sheets functionalities

# USEFUL LINKS

* https://developer.riotgames.com/ you can retrieve your riot key here
* https://console.cloud.google.com/ you can retrieve your google keys

# COMMANDS

* EDITOR="code --wait" bin/rails credentials:edit
* rake cucumber
* bundle exec rspec
* rails s
* rails console
