Rails.application.routes.draw do
  post "roll", to: 'message#roll', as: "roll"
  post "beer", to: 'message#beer', as: "beer"
end
