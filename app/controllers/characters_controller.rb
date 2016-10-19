class CharactersController < ApplicationController
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
                   text: message.new_char_message
                 }
  end

  private

  def message_params
   params.permit(:text, :user_name)
  end
end
