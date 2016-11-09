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
                     text: char.new_character_message
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
    if char.save
      render json: { response_type: "in_channel",
                     text: char.edit_character_message
                   }
    else
      render json: { response_type: "in_channel",
                     text: "#{error_message(char)}\n#{char.character_sheet}"
                   }
    end
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
    output = Character.all.map { |char| "#{char.name} - #{char.actor.name}" }
    render json: { response_type: "in_channel",
                   text: output.join("\n")
                 }
  end

  def equip
    actor = Actor.find_by(name: params[:user_name])
    character = Character.find_by(actor_id: actor.id)
    weapon = Weapon.find_by(name: params[:text])
    if weapon = Weapon.find_by(name: params[:text])
      character.character_weapon.destroy if character.character_weapon.present?
      CharacterWeapon.create!(character: character, weapon: weapon)
      response = "#{character.name} equipped #{weapon.name}"
    end
    render json: { response_type: "in_channel",
                   text: response
                 }
  end

  private
  def error_message(obj)
    "#{obj.errors.first[0].capitalize} #{obj.errors.first[1]}."
  end

  def weapon_params
    params.permit(:text, :user_name)
  end
end
