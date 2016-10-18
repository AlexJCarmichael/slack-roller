Rails.application.routes.draw do
  post "roll", to: 'message#roll', as: "roll"
  post "register", to: 'actor#register', as: "register"
end
