Rails.application.routes.draw do
  post "roll", to: 'message#roll', as: "roll"
  post "new_char", to: 'characters#new_character', as: "new_char"
  post "register", to: 'actor#register', as: "register"
  post "register_character", to: 'actor#register_character', as: "register_character"
end
