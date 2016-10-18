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

    character = Character.create(user_name: user_name, character_name: message.parse_new_character["character_name"])

    attributes = Attribute.create(character_id: character.id,
                        strength:     message.parse_new_character["strength"],
                        dexterity:    message.parse_new_character["dexterity"],
                        constitution: message.parse_new_character["constitution"],
                        intelligence: message.parse_new_character["intelligence"],
                        wisdom:       message.parse_new_character["wisdom"],
                        charisma:     message.parse_new_character["charisma"])

    modifiers = Modifier.create(character_id: character.id,
                      weapon_modifier: message.parse_new_character["weapon_modifier"],
                      armor_modifier:  message.parse_new_character["armor_modifier"])



    render json: { response_type: "in_channel",

                   user_name:     character.user_name,
                   char_name:     character.character_name,

                   strength:      attributes.strength,
                   dexterity:     attributes.dexterity,
                   constitution:  attributes.constitution,
                   intelligence:  attributes.intelligence,
                   wisdom:        attributes.wisdom,
                   charisma:      attributes.charisma,

                   weapon_mod:    modifiers.weapon_modifier,
                   armor_mod:     modifiers.armor_modifier,

                   text: message.new_char_message
                 }
  end

  private

  def message_params
   params.permit(:text, :user_name)
  end
end
