class CharactersController < ApplicationController
  def create
    character = Character.new(char_name: char_name)

    stats = Stat.new(character_id: character.id,
                     str: str, dex: dex, con: con,
                     int: int, wis: wis, cha: cha)

    render json: { response_type: "in_channel",
                   char_name: character.char_name,
                   str: stats.str, dex: stats.dex, con: stats.con,
                   int: stats.int, wis: stats.wis, cha: stats.cha }
  end
end
