Rails.application.routes.draw do
  resources :mods
  resources :stats
  resources :characters
  post "roll", to: 'message#roll', as: "roll"
  post "beer", to: 'message#beer', as: "beer"
  post "new_char", to: 'message#new_character', as: "new_char"
end
