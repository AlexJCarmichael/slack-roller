class MessageController < ApplicationController
  def roll
    body = message_params[:text]
    message = Message.new(body: body, user_name: message_params[:user_name])
    message.roll_dice
    render json: { response_type: "in_channel",
                   text: message.body }
  end

  def beer
    body = message_params[:text]
    user_name = message_params[:user_name]
    message = Message.new(body: body, user_name: user_name)
    render json: { response_type: "in_channel",
                   text: message.beer }
  end

  def new_character
    body = message_params[:text]
    user_name = message_params[:user_name]

    message = Message.new(body: body, user_name: user_name)

    character = Character.create(user_name: user_name, char_name: message.parse_new_character["char_name"])

    stats = Stat.create(character_id: character.id,
                        str: message.parse_new_character["str"],
                        dex: message.parse_new_character["dex"],
                        con: message.parse_new_character["con"],
                        int: message.parse_new_character["int"],
                        wis: message.parse_new_character["wis"],
                        cha: message.parse_new_character["cha"])

    mods = Mod.create(character_id: character.id,
                      weapon_mod: message.parse_new_character["weapon_mod"],
                      armor_mod:  message.parse_new_character["armor_mod"])



    render json: { response_type: "in_channel",
                   user_name: character.user_name,
                   char_name: character.char_name,

                   str: stats.str, dex: stats.dex, con: stats.con,
                   int: stats.int, wis: stats.wis, cha: stats.cha,

                   weapon_mod: mods.weapon_mod,
                   armor_mod:  mods.armor_mod,

                   text: message.new_char_message
                 }
  end

  private

  def message_params
   params.permit(:text, :user_name)
  end
end
