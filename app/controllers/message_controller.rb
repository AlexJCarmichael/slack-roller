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

    parser = message.parse_new_character

    character = Character.new
    character.create_char(parser, message.user_name)

    attributes = Attribute.new
    attributes.create_attributes(parser, character)

    modifiers = Modifier.new
    modifiers.create_modifiers(parser, character)

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
