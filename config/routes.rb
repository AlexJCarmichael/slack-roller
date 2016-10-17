Rails.application.routes.draw do
  resources :stats
  resources :characters
  post "roll", to: 'message#roll', as: "roll"
  post "beer", to: 'message#beer', as: "beer"
  post "new_char", to: 'characters#create', as: "new_char"
end
