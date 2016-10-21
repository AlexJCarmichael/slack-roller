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

  def edit_character
    actor_name = params[:user_name]
    actor = Actor.find_by(name: actor_name)
    message_text = params[:text]
    char = actor.character
    char.edit_char(actor_name, message_text)
    render json: { response_type: "in_channel",
                   text: char.character_sheet
                 }
  end

  def display_character_sheet
    actor = Actor.find_by(name: params[:user_name])
    character = Character.find_by(name: params[:text]) if Character.find_by(name: params[:text])
    bad_input = "Invalid input. Make sure you spelled the character's name correctly."
    output = actor.character.character_sheet
    output = character ? character.character_sheet : bad_input unless (params[:text] == "")
    render json: { response_type: "in_channel",
                   text: output
                 }
  end

  def view_characters
    actor = Actor.find_by(name: params[:user_name])
    other_actor = Actor.find_by(name: params[:text]) if Actor.find_by(name: params[:text])
    bad_input = "Invalid input. Make sure you spelled the user's name correctly."
    output = actor.character_list
    output = other_actor ? other_actor.character_list : bad_input unless (params[:text] == "")
    render json: { response_type: "in_channel",
                   text: output
                 }
  end

  def character_roster
    output = Character.all.map { |char| char.name }
    render json: { response_type: "in_channel",
                   text: output.join("\n")
                 }
  end

  private
  def error_message(obj)
    "#{obj.errors.first[0].capitalize} #{obj.errors.first[1]}."
  end
end
