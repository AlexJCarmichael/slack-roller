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

    character = Character.create(char_name: params[:char_name])

    # stats = Stat.create(character_id: character.id,
    #                     str: params[:str], dex: params[:dex], con: params[:con],
    #                     int: params[:int], wis: params[:wis], cha: params[:cha])
    #
    # mods = Mod.create(character_id: character.id,
    #                   weapon_mod: params[:weapon_mod],
    #                   armor_mod:  params[:armor_mod])

    message = Message.new(body: body, user_name: user_name)


    render json: { response_type: "in_channel",
                   char_name: character.char_name,

                  #  str: stats.str, dex: stats.dex, con: stats.con,
                  #  int: stats.int, wis: stats.wis, cha: stats.cha,
                   #
                  #  weapon_mod: mods.weapon_mod,
                  #  armor_mod:  mods.armor_mod,

                   text: message.new_char
                 }
  end

  private

  def message_params
   params.permit(:text, :user_name)
  end
end
