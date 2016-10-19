class CharactersController < ApplicationController
  def new_character
    actor = params[:user_name]
    message_text = params[:text]
    char = Character.new
    char.new_char(actor, message_text)

    actor = Actor.find_by(name: user_name)
    Character.create_char(parser, actor)

    render json: { response_type: "in_channel",
                   text: Character.new_char_message(body, user_name)
                 }
  end
end
