Rails.application.routes.draw do
  resources :modifiers
  resources :attributes
  resources :characters
  post "roll", to: 'message#roll', as: "roll"
  post "beer", to: 'message#beer', as: "beer"
  post "new_char", to: 'message#new_character', as: "new_char"
end
