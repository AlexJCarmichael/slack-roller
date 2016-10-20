class CharactersController < ApplicationController
  def new_character
    actor_name = params[:user_name]
    actor = Actor.find_by(name: actor_name)
    actor.actor_character.destroy if actor.actor_character
    message_text = params[:text]
    char = Character.new
    char.new_char(actor_name, message_text)
    if char.save
      char.roll_character(message_text)
      ActorCharacter.create!(character: char, actor: actor)
      render json: { response_type: "in_channel",
                     text: char.character_sheet
                   }
    else
      render json: { response_type: "in_channel",
                     text: error_message(char)
                   }
    end
  end

  def display_character_sheet
    actor = Actor.find_by(name: params[:user_name])
    character = Character.find_by(name: params[:text]) if Character.find_by(name: params[:text])
    output = character || actor.character
    render json: { response_type: "in_channel",
                   text: output.character_sheet
                 }
  end

  def view_characters
    actor = Actor.find_by(name: params[:user_name])
    actor = Actor.find_by(name: params[:text]) if Actor.find_by(name: params[:text])
    render json: { response_type: "in_channel",
                   text: actor.character_list
                 }
  end

  private
  def error_message(obj)
    "#{obj.errors.first[0].capitalize} #{obj.errors.first[1]}."
  end
end
