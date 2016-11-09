Rails.application.routes.draw do
  get "helpdw", to: 'message#help', as: "helpdw"

  post "roll", to: 'message#roll', as: "roll"

  post "character",          to: 'characters#display_character_sheet', as: "character"
  post "characters",         to: 'characters#view_characters',         as: "characters"
  post "new_char",           to: 'characters#new_character',           as: "new_char"
  post "character_roster",   to: 'characters#character_roster',        as: "character_roster"
  post "edit_char",          to: 'characters#edit_character',          as: "edit_char"
  post "new_weapon",         to: 'weapons#new_weapon',                 as: "new_weapon"
  post "weapons",            to: 'weapons#weapons',                    as: "weapons"
  post "weapon",             to: 'weapons#weapon',                     as: "weapon"
  post "equip",              to: 'weapons#equip',                      as: "equip"

  post "register",           to: 'actors#register',           as: "register"
  post "register_character", to: 'actors#register_character', as: "register_character"
  post "roster",             to: 'actors#roster',             as: "roster"

end
