Rails.application.routes.draw do
  resources :modifiables
  resources :statables
  post "roll", to: 'message#roll', as: "roll"
  post "beer", to: 'message#beer', as: "beer"
  post "new_char", to: 'characters#new_character', as: "new_char"
  post "register", to: 'actor#register', as: "register"
end
