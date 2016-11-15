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
    character = find_character
    bad_input = "Invalid input. Make sure you spelled the character's name correctly."
    output = actor.character.character_sheet
    output = character ? character.character_sheet : bad_input unless (params[:text] == "")
    render json: { response_type: "in_channel",
                   text: output
                 }
  end

  def view_characters
    actor = Actor.find_by(name: params[:user_name])
    other_actor = find_actor
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
    character = actor.character
    if weapon = find_weapon
      character.character_weapon.destroy if character.character_weapon.present?
      CharacterWeapon.create!(character: character, weapon: weapon)
      output = "#{character.name} equipped the weapon: #{weapon.name}"
      output = "#{character.name} equipped the weapon: #{weapon.quality} #{weapon.name}" if weapon.quality
    else
      output = "Weapon does not exist. Create it by typing `/new_weapon name: <weapon_name>`"
    end
    render json: { response_type: "in_channel",
                   text: output
                 }
  end

  private
  def error_message(obj)
    "#{obj.errors.first[0].capitalize} #{obj.errors.first[1]}."
  end

  def find_character
    character_name = Character.new.character_name(params[:text])
    character = Character.find_by(name: character_name)
    character
  end

  def find_actor
    actor_name = Actor.new.actor_name(params[:text])
    actor = Actor.find_by(name: actor_name)
    actor
  end

  def find_weapon
    weapon_name = Weapon.new.weapon_name(params[:text])
    weapon = Weapon.find_by(name: weapon_name)
    weapon
  end
end
