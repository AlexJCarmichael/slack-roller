class CharactersController < ApplicationController
  def new_character
    user_name = params[:user_name]
    body = params[:text]
    parser = Character.parse_new_character(body)

    actor = Actor.find_by(name: user_name)
    Character.create_char(parser, actor)

    render json: { response_type: "in_channel",
                   text: Character.new_char_message(body, user_name)
                 }
  end
end
