class CharactersController < ApplicationController
  def new_character
    user_name = params[:user_name]
    message = Message.new(body: params[:text], user_name: user_name)
    parser = message.parse_new_character

    actor = Actor.find_by(name: user_name)

    character = Character.create_char(parser, actor)
    Stat.create_stats(parser, character)
    Modifier.create_modifiers(parser, character)

    render json: { response_type: "in_channel",
                   text: message.new_char_message
                 }
  end
end
