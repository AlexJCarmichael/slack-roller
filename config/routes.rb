Rails.application.routes.draw do
  post "roll", to: 'message#roll', as: "roll"
end
