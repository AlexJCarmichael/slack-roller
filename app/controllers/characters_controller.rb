class CharactersController < ApplicationController
  def create
    character = Character.create(char_name: params[:char_name])

    stats = Stat.create(character_id: character.id,
                        str: params[:str], dex: params[:dex], con: params[:con],
                        int: params[:int], wis: params[:wis], cha: params[:cha])

    mods = Mod.create(character_id: character.id,
                      weapon_mod: params[:weapon_mod],
                      armor_mod:  params[:armor_mod])

    render json: { response_type: "in_channel",
                   char_name: character.char_name,

                   str: stats.str, dex: stats.dex, con: stats.con,
                   int: stats.int, wis: stats.wis, cha: stats.cha,

                   weapon_mod: mods.weapon_mod,
                   armor_mod:  mods.armor_mod
                 }
  end
end
